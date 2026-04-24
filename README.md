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

## Deployment

This repo deploys with GitHub Actions on push to `main`.

1. Commit and push changes to `main`
2. Ensure GitHub setting is `Pages -> Source -> GitHub Actions`
3. Wait for workflow `Deploy Jekyll site to Pages` to pass

## Content notes

- Posts are migrated from WordPress and preserved in HTML-in-Markdown format for fidelity.
- Image links are rewritten to local `assets/images/...` paths.
- Keeping all images in this repo is intentional because this repository is used as a complete backup.

## Suggested GitHub About (copy/paste)

Description:

`WordPress blog migrated to Jekyll and hosted on GitHub Pages, with local image assets preserved for long-term backup.`

Topics:

`jekyll, github-pages, wordpress-migration, blog, static-site, markdown, backup, ruby`
