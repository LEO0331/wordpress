#!/usr/bin/env python3
"""Sync public WordPress.com posts without changing the original XML archive."""

import argparse
from datetime import datetime
import html
import json
from pathlib import Path
import re
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.parse import quote, unquote, urlencode, urlsplit
from urllib.request import Request, urlopen

import nh3

SITE = "leolicheng.wordpress.com"
ROOT = Path(__file__).resolve().parents[1]
URL_RE = re.compile(r'https?://[^\s"\'<>]+')
IMAGE_PATH = re.compile(
    r'\d{4}/\d{2}/[^/\\:*?"<>|\x00-\x1f]+\.(?:jpg|jpeg|png|gif|webp|avif)',
    re.IGNORECASE,
)
SRCSET_CANDIDATE = re.compile(
    r'https?://[^\s,\\"\'<>]+[ \t]+(?:[1-9][0-9]*w|[0-9]+(?:\.[0-9]+)?x)',
    re.IGNORECASE,
)
EMBED_PATHS = {
    "www.youtube.com": "/embed/",
    "www.youtube-nocookie.com": "/embed/",
    "player.vimeo.com": "/video/",
    "open.spotify.com": "/embed/",
}


def filter_content_attribute(tag, attribute, value):
    if attribute == "style" and any(character in value for character in "()\\"):
        # Keep plain formatting values and reject CSS functions and escaped tokens.
        return None
    if attribute == "srcset":
        # WordPress emits comma-separated HTTP(S) URLs with width or density descriptors.
        candidates = [candidate.strip() for candidate in value.split(",")]
        if all(SRCSET_CANDIDATE.fullmatch(candidate) for candidate in candidates):
            return ", ".join(candidates)
        return None
    if tag == "iframe" and attribute == "src":
        try:
            url = urlsplit(value)
        except ValueError:
            return None
        prefix = EMBED_PATHS.get(url.netloc.lower())
        if url.scheme != "https" or not prefix or not url.path.startswith(prefix):
            return None
    return value


CONTENT_CLEANER = nh3.Cleaner(
    tags=nh3.ALLOWED_TAGS | {"audio", "figure", "figcaption", "iframe", "source", "video"},
    attributes={
        **nh3.ALLOWED_ATTRIBUTES,
        "*": {"class", "dir", "lang", "style", "title"},
        "a": nh3.ALLOWED_ATTRIBUTES["a"] | {"target"},
        "audio": {"controls", "loop", "muted", "preload", "src"},
        "iframe": {"allowfullscreen", "height", "loading", "src", "width"},
        "img": nh3.ALLOWED_ATTRIBUTES["img"] | {"decoding", "loading", "sizes", "srcset"},
        "source": {"sizes", "src", "srcset", "type"},
        "video": {"controls", "height", "loop", "muted", "playsinline", "poster", "preload", "src", "width"},
    },
    attribute_filter=filter_content_attribute,
    set_tag_attribute_values={
        "iframe": {"sandbox": "allow-scripts allow-same-origin allow-presentation"},
    },
    filter_style_properties={
        "aspect-ratio", "color", "font-size", "height", "max-width",
        "object-fit", "text-align", "white-space", "width",
    },
    url_schemes={"http", "https", "mailto", "tel"},
)


def fetch(url):
    for attempt in range(3):
        try:
            with urlopen(Request(url, headers={"User-Agent": "WordPress-Jekyll-Archive/1.0"}), timeout=60) as response:
                return response.read()
        except (HTTPError, URLError, TimeoutError) as error:
            if isinstance(error, HTTPError) and error.code not in (429, 500, 502, 503, 504):
                raise
            if attempt == 2:
                raise
            time.sleep(2 ** attempt)


def fetch_posts():
    posts = []
    seen = set()
    page = 1
    while True:
        query = urlencode({"number": 100, "page": page, "order_by": "ID", "order": "ASC", "status": "publish", "type": "post"})
        data = json.loads(fetch(f"https://public-api.wordpress.com/rest/v1.1/sites/{SITE}/posts/?{query}"))
        batch = data["posts"]
        if not batch and len(posts) < data["found"]:
            raise ValueError("WordPress pagination ended before all posts were retrieved")
        for post in batch:
            if post["ID"] in seen:
                raise ValueError("Duplicate ID during pagination; retry with a stable source")
            if post["status"] != "publish" or post.get("type", "post") != "post":
                raise ValueError("Unexpected non-public post in API response")
            seen.add(post["ID"])
            posts.append(post)
        if len(posts) == data["found"]:
            return posts
        if len(posts) > data["found"]:
            raise ValueError("WordPress post count changed during pagination; retry")
        page += 1


def slug_for(post):
    slug = re.sub(r"[^\w%.-]+", "-", post["slug"], flags=re.UNICODE).strip("-").lower()
    slug = re.sub(r"\.{2,}", ".", slug)
    if not slug or slug in (".", ".."):
        raise ValueError(f"Unsafe or empty slug for post {post['ID']}")
    return slug


def rewrite_images(content, root, check):
    def replace(match):
        url = html.unescape(match.group())
        try:
            parsed = urlsplit(url)
        except ValueError:
            return match.group()
        if parsed.hostname == SITE and parsed.path.startswith("/wp-content/uploads/"):
            path = unquote(parsed.path[len("/wp-content/uploads/"):])
        elif parsed.hostname == "leolicheng.files.wordpress.com":
            path = unquote(parsed.path).lstrip("/")
        else:
            return match.group()
        if not IMAGE_PATH.fullmatch(path):
            return match.group()
        target = root / "assets" / "images" / path
        if not target.is_file() and not check:
            data = fetch(f"https://leolicheng.files.wordpress.com/{quote(path)}")
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
        return "{{ '/assets/images/" + quote(path) + "' | relative_url }}"
    return URL_RE.sub(replace, content)


def render_post(post, root, check):
    # A JSON object is valid YAML; the Jekyll front matter needs no Python YAML dependency.
    date = datetime.fromisoformat(post["date"])
    metadata = {
        "layout": "post", "title": html.unescape(post["title"]),
        "date": date.isoformat(sep=" "), "author": post["author"]["login"],
        "categories": sorted(html.unescape(c["name"]) for c in post["categories"].values()),
        "tags": sorted(html.unescape(t["name"]) for t in post["tags"].values()),
        "wordpress_id": post["ID"], "wordpress_url": post["URL"],
        "wordpress_modified": post["modified"],
    }
    content = CONTENT_CLEANER.clean(post["content"])
    # Neutralize source Liquid before adding the importer-owned image expressions.
    content = rewrite_images(content.replace("{", "&#123;"), root, check)
    # Keep Markdown from interpreting sanitized WordPress HTML or its text as markup.
    front_matter = json.dumps(metadata, ensure_ascii=False, indent=2)
    return f'---\n{front_matter}\n---\n\n<div markdown="0">\n{content.rstrip()}\n</div>\n'


def sync(posts, root=ROOT, check=False):
    directory = root / "_posts"
    existing = list(directory.glob("*.md")) + list(directory.glob("*.markdown"))
    managed = {}
    for path in existing:
        text = path.read_text(encoding="utf-8")
        match = re.search(r'^\s*"wordpress_id":\s*(\d+)', text, re.MULTILINE)
        if match:
            identity = int(match[1])
            if identity in managed:
                raise ValueError(f"Duplicate archived WordPress ID {identity}")
            managed[identity] = path
    counts = {"added": 0, "updated": 0, "preserved": 0, "unchanged": 0}
    plans = []
    targets = set()
    for post in posts:
        date = datetime.fromisoformat(post["date"]).strftime("%Y-%m-%d")
        target = managed.get(post["ID"], directory / f"{date}-{slug_for(post)}.md")
        if target in targets:
            raise ValueError(f"Posts resolve to the same path: {target.name}")
        targets.add(target)
        if target.exists() and post["ID"] not in managed:
            counts["preserved"] += 1
            continue
        action = "updated" if target.exists() else "added"
        plans.append((target, post, action))
    # Validate the entire listing before writes, so a failed API fetch never deletes archive content.
    for target, post, action in plans:
        rendered = render_post(post, root, check)
        if target.exists() and target.read_text(encoding="utf-8") == rendered:
            counts["unchanged"] += 1
            continue
        counts[action] += 1
        print(f"{action}: {json.dumps(html.unescape(post['title']), ensure_ascii=False)}")
        if not check:
            directory.mkdir(parents=True, exist_ok=True)
            target.write_text(rendered, encoding="utf-8", newline="\n")
    print(f"WordPress published posts: {len(posts)}; " + "; ".join(f"{key}={value}" for key, value in counts.items()))
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Report additions/updates without writing posts or images")
    args = parser.parse_args()
    try:
        sync(fetch_posts(), check=args.check)
    except (HTTPError, URLError, TimeoutError, ValueError, KeyError, OSError) as error:
        print(f"Sync failed: {json.dumps(str(error), ensure_ascii=False)}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
