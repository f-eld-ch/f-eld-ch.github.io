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
A weekly workflow (`.github/workflows/hugo-update.yaml`, `scripts/update-hugo.sh`) opens a pull request when a new
Hugo release is out, after a test build; `scripts/update-hugo.sh --dry-run` shows what it would do.

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
scripts/sync-brand.sh      copy the F-ELD lockups from ../brand
scripts/update-hugo.sh      weekly Hugo upgrade check (used by the hugo-update workflow)
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
- **Logo:** the F-ELD lockups come from the `f-eld-ch/brand` repository (`logo/feld-lockup-*.svg`: the
  sitrep symbol with the wordmark F-ELD). `scripts/sync-brand.sh` copies the four used variants to
  `static/brand/lockup-*.svg`, which override the sitrep.ch lockups of the theme. The proportions differ
  (308×96 instead of 393×96), so the logo images in `layouts/partials/header.html` and `layouts/index.html`
  set their own `width`, `height` and `aspect-ratio`. The favicon is the shared symbol.

## Content

- German is the default language and lives at `/`, French at `/fr/`, Italian at `/it/`. Translate a content file
  with a sibling `*.fr.md` / `*.it.md` and give it a translated `slug:` (for example `verein.fr.md` →
  `/fr/association/`). Menus are defined per language in `hugo.toml`. UI strings come from the theme
  (`themes/sitrep/i18n`).
- Translations are drafted by us and **should be reviewed by native speakers**. Use the same terms as sitrep.ch
  (FR: états-majors, aide à la conduite, membre donateur; IT: stati maggiori, aiuto alla condotta, socio
  sostenitore). The association name stays *Verein Förderung der elektronischen Lagedarstellung*.
- Address readers with "Sie" in German, "vous" in French, "voi" in Italian. Keep the voice plain and direct. The association is written **F-ELD**, the
  software always **`sitrep`** (lowercase).
- Only state facts you can source (the statutes, the sitrep README). Do not invent prices, membership terms,
  training offers or dates. Facts so far: non-profit association under Art. 60 ff. ZGB with seat in Altdorf UR;
  purpose is the promotion and spread of digital situation management in command staffs and the development
  and spread of open-source software for it; it works non-profit and uses all income for its purpose;
  organs are honorary; it offers sitrep trainings for Gönnermitglieder (supporting members).
- Questions about the association go to `info@f-eld.ch` (`params.email`, also the footer link). Questions about sitrep or
  the service go to `info@sitrep.ch`.
- Link to sitrep via `params.sitrep` or `https://sitrep.ch`; do not duplicate its product content here.
- Link between pages with `{{< relref "/path" >}}`.

## Deployment

`main` → Cloudflare Workers Builds → <https://f-eld.ch>. The Worker is `f-eld-ch` (`wrangler.jsonc`), the build
command is `scripts/cloudflare-build.sh`, the deploy command `npx wrangler deploy`. Other branches get a
preview build (drafts included, `noindex`) at `https://<branch>-f-eld-ch.f-eld.workers.dev/`.
`www.f-eld.ch` redirects to `f-eld.ch` (Redirect Rule in the Cloudflare dashboard, not in this repo).

## License

Code (theme, layouts, scripts, workflows, configuration) is **AGPL-3.0** (`LICENSE`), the texts in `content/` are
**CC BY-SA 4.0** (`LICENSE-CONTENT`). The logos and the names F-ELD and sitrep are not covered, see the README. Do not
add third-party material or text without checking that it may be reused. Do not change the license files.
