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

## Importing new posts from WordPress XML

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
