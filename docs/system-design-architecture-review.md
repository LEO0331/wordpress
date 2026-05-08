# System Design Review: WordPress -> Jekyll Migration Project

Last updated: 2026-05-08

## 1. System Scope and Goals

This system converts a WordPress-exported content archive into a GitHub Pages-hosted Jekyll site.

Primary goals:
- Long-term ownership of content in plain files.
- Deterministic static builds and low operational overhead.
- Strong privacy and security baseline (no server runtime, reduced attack surface).
- Good Lighthouse quality through CI guardrails.

Non-goals:
- Dynamic CMS editing in production.
- Runtime database queries.
- User authentication, personalization, or online write APIs.

## 2. High-Level Architecture

## 2.1 Build-Time Pipeline
- Input sources:
  - WordPress XML: `my-site/import/leo.WordPress.2026-04-23.xml`
  - Local media files: `my-site/assets/images/...`
- Conversion step:
  - `my-site/scripts/wordpress_to_jekyll.rb`
  - Produces `_posts/YYYY-MM-DD-slug.md` with front matter and HTML body.
  - Rewrites matching media URLs to local `relative_url` paths only when target file exists.
- Taxonomy step:
  - `my-site/scripts/generate_category_pages.rb`
  - Generates `my-site/category/*.markdown` and `my-site/categories.markdown`.
- Site build step:
  - `bundle exec jekyll build`

## 2.2 Runtime Model (Static Delivery)
- Rendered static site served by GitHub Pages.
- No application server, no runtime DB.
- Optional client-side behaviors:
  - Homepage "load more" interactions.
  - Service worker registration for PWA baseline.

## 2.3 CI/CD and Quality Gates
- Deployment workflow: `.github/workflows/deploy-pages.yml`.
- Lighthouse workflow: `.github/workflows/lighthouse-ci.yml` + `.lighthouserc.json`.
- Checks include performance, accessibility, best-practices, SEO thresholds.

## 3. Component-Level Design Review

## 3.1 Content Conversion Service (`wordpress_to_jekyll.rb`)

Responsibilities:
- Parse XML safely (reject DOCTYPE/ENTITY).
- Filter only published posts.
- Map WordPress fields -> Jekyll front matter.
- Rewrite image URLs conditionally.
- Report dry-run/write metrics and unmatched URLs.

Strengths:
- Good safety baseline (XXE-related guard via DOCTYPE/ENTITY rejection).
- Path traversal defensive checks when resolving output and image paths.
- Collision-safe by default (skip existing filenames).

Tradeoffs:
- Skipping collisions protects edits, but complicates true updates from WordPress.
- URL rewrite uses heuristic matching for WordPress URL patterns; uncommon media URLs may remain unmatched.

## 3.2 Taxonomy Generator (`generate_category_pages.rb`)

Responsibilities:
- Scan front matter categories from all posts.
- Count categories and generate category pages and index.

Strengths:
- Deterministic output from source posts.
- Handles slug collisions deterministically.

Tradeoffs:
- Full rescan of `_posts` each run (acceptable at current scale).
- Category metadata is derived, not manually curated per category.

## 3.3 Homepage Curation (`_layouts/home.html`)

Responsibilities:
- Compose "封面故事", "編輯精選", "生活", "精選文章" sections.
- Apply pinned titles and topic-priority rules.
- Use client-side progressive reveal for larger lists.

Strengths:
- Curated ordering gives editorial control.
- De-duplication across sections avoids repeated items.

Tradeoffs:
- Liquid template contains non-trivial selection logic (higher template complexity).
- Behavior is deterministic but can be harder to test than app-code selectors.

## 4. Data Structures: Why Chosen, Alternatives, Tradeoffs

## 4.1 Persistent Storage: Filesystem Hierarchy
Chosen:
- Markdown files in `_posts`.
- Images under `assets/images/YYYY/MM/...`.

Why this structure:
- Native fit for Jekyll conventions.
- Version control friendly (Git diff/review/history).
- Zero runtime dependency and easy backups.

Alternatives:
- SQLite/content DB + static export.
- Headless CMS API as source of truth.

Why not alternatives now:
- Adds infrastructure/lock-in and operational overhead.
- Conflicts with backup-portability-first goal.

## 4.2 Front Matter Structure: YAML Hash + Arrays
Chosen:
- Per post metadata hash (`title`, `date`, `author`) with arrays for `categories`, `tags`.

Why this structure:
- Jekyll-native and human-editable.
- Compatible with Liquid filters and category grouping.

Alternatives:
- JSON blobs in post body.
- External metadata index file.

Tradeoff:
- YAML is flexible but less schema-rigid than typed stores.

## 4.3 Category Aggregation: Ruby Hash Map
Chosen:
- `Hash<String, Integer>` for category counts in generator script.

Why this structure:
- O(1) average updates while scanning posts.
- Simple and deterministic for static generation.

Alternatives:
- Sort-based grouping without hash.
- Tree/ordered map keyed by locale-aware collation.

Tradeoff:
- Plain hash then sort is fast and simple, but locale-specific ordering logic is limited.

## 4.4 Section De-dup Tracking in Liquid: Delimited String Set Emulation
Chosen:
- Delimited URL accumulator strings (e.g., `|url|...`) in Liquid.

Why this structure:
- Liquid has limited native set operations.
- Works without plugins/custom Ruby runtime hooks.

Alternatives:
- Jekyll plugin to provide true set operations.
- Precompute curated lists in build script and pass as data file.

Tradeoff:
- Current method is verbose and less readable.
- A precompute step would improve maintainability but adds another build artifact stage.

## 4.5 URL Detection/Rewriting: Regex + URI Parse Hybrid
Chosen:
- Broad URL regex extraction + URI parsing + host/path rules.

Why this structure:
- Practical balance: catches URLs in HTML fragments while validating path/host semantics.

Alternatives:
- Full HTML parsing and attribute-level rewriting only.
- XML DOM transformation before Markdown generation.

Tradeoff:
- Regex can overmatch edge punctuation; code mitigates with trailing punctuation stripping.
- Full DOM parsing is cleaner semantically but more complex for mixed content.

## 4.6 Metrics and Reporting: Hash Counters
Chosen:
- `Hash<Symbol, Integer>` for conversion stats and unmatched URL counts.

Why this structure:
- Minimal overhead and very readable in scripts.

Alternatives:
- Structured logging JSON events.
- SQLite run-history table.

Tradeoff:
- Current report is enough for manual operation; lacks historical trend analytics.

## 5. Key Architectural Tradeoffs

1. Static simplicity vs dynamic flexibility
- Chosen static model minimizes ops/security cost.
- Loses runtime personalization/search APIs unless added client-side or externalized.

2. Deterministic build vs template complexity
- Build outputs are reproducible.
- More complex homepage Liquid logic can reduce maintainability.

3. Safety-first migration vs update convenience
- Collision skip avoids accidental overwrite.
- Requires manual refresh path for changed historical posts.

4. Plugin-minimal approach vs stronger abstractions
- Works well on GitHub Pages constraints.
- Limits ability to use richer data structures or custom selectors directly in Liquid.

## 6. Scaling and Reliability Considerations

Current scale fit:
- Hundreds of posts are well within static generation comfort range.
- Image-heavy repo size is manageable for backup-first use, but clone/build times grow over time.

Future pressures and options:
- If post volume grows a lot, precompute curated lists into `_data/*.yml` to simplify template logic.
- If media size grows significantly, move original-resolution assets to object storage/CDN and keep web-optimized derivatives locally.

## 7. Security and Privacy Posture Review

Strengths:
- No server runtime means reduced injection/auth attack surface.
- XML safety checks present.
- URL rewrite only targets local files that exist, reducing broken-link rewrites.

Residual risks:
- Historical post bodies may still contain old external links or sensitive text if not scrubbed.
- Public Git history can preserve removed secrets if previously committed.

Recommended hardening:
- Add a CI privacy scan for email/phone/IP patterns in posts and XML.
- Add pre-commit hook for obvious secret patterns.
- Periodic link and privacy audit scripts.

## 8. Alternative Architecture Paths

## Option A: Keep current architecture (recommended now)
Best when:
- Prioritizing low ops, deterministic builds, and backup ownership.

## Option B: Add a precompute curation stage
What changes:
- Move complex homepage selection logic into a Ruby script that emits curated `_data/home.yml`.
Pros:
- Cleaner templates, easier testability.
Cons:
- Additional generation step and artifact coupling.

## Option C: Hybrid static + external search/index service
What changes:
- Keep static pages but add external index for search/filter UX.
Pros:
- Better discoverability for large archives.
Cons:
- Adds integration and service dependency.

## 9. Deep-Dive Interview Q&A Prep

## Q1: Why choose static files over a database-backed CMS?
A: Content ownership, low operational cost, deterministic builds, and strong portability were prioritized over runtime editing convenience.

## Q2: How do you guarantee migration safety?
A: XML safety checks, path traversal guards, filename collision skipping, and dry-run reporting before write mode.

## Q3: Why skip filename collisions instead of overwrite?
A: Prevents accidental data loss of manually edited Markdown; updates can be explicit and controlled.

## Q4: Why use host/path-based image rewrite rules?
A: They tightly scope rewriting to known WordPress patterns and avoid mutating third-party URLs.

## Q5: Why keep post body as HTML-in-Markdown?
A: Lossless migration and predictable rendering. Full HTML-to-Markdown conversion risks semantic regressions.

## Q6: Why generate category pages instead of computing at runtime?
A: Static generation aligns with no-server architecture and keeps rendering deterministic.

## Q7: Why emulate sets with delimited strings in Liquid?
A: GitHub Pages-compatible Liquid lacks robust set primitives without custom plugins.

## Q8: What would you refactor first for maintainability?
A: Move homepage selection into a precompute data step (`_data/home.yml`) with unit-testable Ruby selection logic.

## Q9: How do you manage quality regressions?
A: CI Lighthouse thresholds and reproducible Jekyll builds on every push/PR.

## Q10: Biggest current architectural risk?
A: Template logic complexity in homepage curation; functional but harder to reason about and test than code-based selectors.

## Q11: How would you support incremental XML imports safely?
A: Add deterministic content fingerprinting per post and an "update mode" flag to selectively overwrite unchanged-safe fields.

## Q12: How would you reduce repo bloat from images?
A: Keep originals in archival storage, generate optimized web derivatives, and optionally use LFS/CDN for originals.

## Q13: How would you improve privacy controls?
A: Automated PII scanners in CI, explicit allowlists, and scrub reports with fail-on-new-sensitive-pattern behavior.

## Q14: How to test migration correctness deeply?
A: Golden-file tests for representative posts, rewrite rule fixtures, and diff-based assertions on generated front matter/body.

## Q15: What is the fallback if PWA behavior breaks?
A: Site remains fully functional as static pages; PWA layer is additive, not a hard dependency for content delivery.

## 10. Practical Next Steps (Prioritized)

1. Introduce `_data/home.yml` precompute for curated sections.
2. Add CI privacy scan for posts/XML.
3. Add migration fixture tests for URL rewrite edge cases.
4. Document operational runbook for "new XML import -> regenerate categories -> build -> deploy".

