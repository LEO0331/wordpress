# Leo's WordPress-to-GitHub Blog Archive

This repository contains a migrated version of a WordPress blog, rebuilt as a Jekyll site and deployed on GitHub Pages.

## What this project is

- A static backup of blog posts originally written on WordPress
- A GitHub-hosted Jekyll website for long-term ownership and portability
- A source archive that can later be synced to tools like Obsidian

## Live site

- GitHub Pages URL: `https://leo0331.github.io/wordpress/`

## Project structure

- `my-site/`: Jekyll source site
- `my-site/_posts/`: Migrated Markdown/HTML posts
- `my-site/assets/images/`: Local image assets used by posts
- `my-site/import/`: Original WordPress export XML
- `my-site/scripts/wordpress_to_jekyll.rb`: Migration + image-link rewrite script
- `.github/workflows/deploy-pages.yml`: GitHub Pages deployment workflow

## Local development

Prerequisites:

- Ruby `3.4.1`
- Bundler `2.6.2`

Commands:

```bash
cd my-site
bundle install
bundle exec jekyll serve
```

Then open: `http://127.0.0.1:4000/wordpress/`

## Automatic WordPress updates

The public source is [leolicheng.wordpress.com](https://leolicheng.wordpress.com/).
`.github/workflows/sync-wordpress.yml` runs on January, April, July, and October 1
at approximately **09:17 Asia/Taipei**. It can also run on demand from GitHub
Actions → **Sync WordPress archive quarterly** → **Run workflow**.

The workflow fetches all published posts through the WordPress.com public API,
imports missing articles with their WordPress categories and tags, downloads
images hosted on this blog's WordPress media domain, regenerates category pages,
tests the importer, builds Jekyll, commits archive changes, and deploys GitHub
Pages. New categories are generated automatically; no manual category code is
needed. No WordPress password or personal access token is required.

The workflow must be on `main`, Actions must be enabled, and repository rules
must allow `github-actions[bot]` to push to `main`. Pages must use GitHub Actions
(as in the existing deployment workflow). Scheduled runs may be delayed, and
GitHub can disable schedules in public repositories after 60 days without
activity; check the Actions page if updates stop.

Run locally with Python 3.10+ (standard library only):

```bash
python my-site/scripts/sync_wordpress.py --check  # read-only comparison
python my-site/scripts/sync_wordpress.py          # import/update
cd my-site
bundle exec ruby scripts/generate_category_pages.rb
bundle exec jekyll build
```

Existing XML-imported posts are preserved, including local edits and image
rewrites. Posts first imported by the API script carry a WordPress ID and are
refreshed on later runs, including content/category changes, while preserving
their archive filename if the source slug changes. Edit those posts in WordPress,
since local changes to API-managed posts will be overwritten. Archived posts are
never deleted when their source disappears. Drafts/private posts, comments,
WordPress pages, and externally hosted media are outside this sync's scope.

## Importing posts from WordPress XML

Use the built-in migration script. You do not need to manually convert XML to Markdown.

```bash
cd my-site
bundle exec ruby scripts/wordpress_to_jekyll.rb \
  --xml import/leo.WordPress.2026-04-23.xml \
  --posts-dir _posts
```

Notes:

- Existing post filename collisions are skipped (safe default).
- This means re-running the script will add new posts and keep existing files.
- If you edited a post on WordPress and want to refresh that same post file, remove that specific `_posts/YYYY-MM-DD-slug.md` and run the script again.

## Regenerating category pages

After adding or changing posts/categories, regenerate category pages and category index:

```bash
cd my-site
bundle exec ruby scripts/generate_category_pages.rb
```

This updates:

- `my-site/category/*.markdown` (one page per category)
- `my-site/categories.markdown` (all categories index)
