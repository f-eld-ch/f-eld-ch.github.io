# AGENTS.md

Guidance for working in this repository (humans and coding agents alike).

This is the website of the **Verein F-ELD** (Förderung der elektronischen Lagedarstellung), published at
<https://f-eld.ch>. It is a [Hugo](https://gohugo.io) site that uses the **same theme and design as
sitrep.ch** (`../sitrep.ch`). The association's software, **sitrep**, has its own site, <https://sitrep.ch>:
this site mentions sitrep and links to it, but is about the association (purpose, organisation, Gönnermitgliedschaft).

## Working rules

- **The live site deploys from `main`** (Cloudflare Workers Builds, `scripts/cloudflare-build.sh`). Work on a
  branch, never push to `main`, and do not push or open PRs unless asked.
- Commit only when asked. Use small commits grouped by topic with conventional-style messages.
- Do not leave generated output behind: `public/` and `resources/` are git-ignored.

## Commands

The Hugo version is pinned in **`.hugo-version`** (single source of truth, read by the Cloudflare build and
the GitHub workflow). The non-extended build is enough.

```sh
hugo server                 # live preview on http://localhost:1313
hugo --gc --minify          # production build into public/
hugo --gc -d /tmp/out       # build elsewhere to avoid touching public/
scripts/sync-theme.sh       # copy the theme from ../sitrep.ch
```

A change is not done until the site builds **without errors or warnings** and you have looked at the
affected pages (light and dark mode, a narrow viewport of ~400px).

## Repository layout

```
hugo.toml                  config, menu, params (email, sitrep URL)
content/                   _index.md (home), verein.md, goenner.md
layouts/                   site specific overrides: index.html (home), partials/header.html, partials/footer.html
static/                    site specific static files (overrides of the theme, e.g. brand/ logos)
themes/sitrep/             COPY of the theme of sitrep.ch, do not edit (see below)
scripts/sync-theme.sh      copy the theme from ../sitrep.ch
scripts/cloudflare-build.sh  build script for Cloudflare Workers Builds
wrangler.jsonc             Cloudflare Workers config: serves public/ as static assets
.hugo-version              pinned Hugo version
.github/workflows/hugo.yaml  GitHub Pages deployment, to be removed after the move to Cloudflare
```

## The theme

- `themes/sitrep` is a copy of `../sitrep.ch/themes/sitrep`. **Never edit it here.** Change the theme in the
  sitrep.ch repository and run `scripts/sync-theme.sh`, so both sites keep the same design. Site specific
  changes go into `layouts/` (they override the theme's files) and `static/`.
- Design rules (brand tokens, one font family, light/dark mode, 44px touch targets, no JS dependencies) are
  described in the AGENTS.md of sitrep.ch.
- **Logo:** `static/brand/feld-lockup-light.png` and `feld-lockup-dark.png` are a **temporary raster draft** of the
  F-ELD lockup (transparent, trimmed, the dark one has a white wordmark), used by `layouts/partials/header.html`
  and `layouts/index.html`. Replace them with the SVG lockups once they are in the `f-eld-ch/brand` repository
  (same names as in the theme: `lockup-on-paper.svg`, `lockup-on-ink.svg`, `lockup-blue.svg`, `lockup-white.svg`)
  and adjust `width`, `height` and the inline `aspect-ratio` of the logo images to the new proportions.

## Content

- German only (`/`). French and Italian can be added like on sitrep.ch (`*.fr.md`, `*.it.md`, menus per
  language, translated URLs via `slug:`); translations should be reviewed by native speakers.
- Address readers with "Sie". Keep the voice plain and direct. The association is written **F-ELD**, the
  software always **`sitrep`** (lowercase).
- Only state facts you can source (the statutes, the sitrep README). Do not invent prices, membership terms,
  training offers or dates. Facts so far: non-profit association under Art. 60 ff. ZGB with seat in Altdorf UR;
  purpose is the promotion and spread of digital situation management in command staffs and the development
  and spread of open-source software for it; it works non-profit and uses all income for its purpose;
  organs are honorary; it offers sitrep trainings for Gönnermitglieder (supporting members).
- The contact address is `info@sitrep.ch` (`params.email`).
- Link to sitrep via `params.sitrep` or `https://sitrep.ch`; do not duplicate its product content here.
- Link between pages with `{{< relref "/path" >}}`.

## Deployment

`main` → Cloudflare Workers Builds → <https://f-eld.ch>. The Worker is `f-eld-ch` (`wrangler.jsonc`), the build
command is `scripts/cloudflare-build.sh`, the deploy command `npx wrangler deploy`. Other branches get a
preview build (drafts included, `noindex`) at `https://<branch>-f-eld-ch.f-eld.workers.dev/`.
`www.f-eld.ch` redirects to `f-eld.ch` (Redirect Rule in the Cloudflare dashboard, not in this repo).
