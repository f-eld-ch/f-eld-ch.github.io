# f-eld.ch

The website of the **Verein F-ELD** (Förderung der elektronischen Lagedarstellung), published at <https://f-eld.ch>:
purpose and organisation of the association and the supporting membership (Gönnermitgliedschaft), in German, French
and Italian.

The association's software, **sitrep**, has its own site, <https://sitrep.ch>
([f-eld-ch/sitrep.ch](https://github.com/f-eld-ch/sitrep.ch)). This site mentions sitrep and links to it, and uses the
same theme and design. The F-ELD logos come from the [brand repository](https://github.com/f-eld-ch/brand) (private).

The site is built with [Hugo](https://gohugo.io).

## Preview and build

Install Hugo in the version pinned in [`.hugo-version`](.hugo-version), then:

```sh
hugo server            # live preview on http://localhost:1313
hugo --gc --minify     # production build into public/
```

## What is where

| Path | Content |
| --- | --- |
| `content/` | Home, the association and the supporting membership, in German with `*.fr.md` and `*.it.md` translations |
| `layouts/` | Overrides of the theme for this site: home page, header, footer |
| `static/brand/` | The F-ELD lockups (copied from the brand repository with `scripts/sync-brand.sh`) |
| `themes/sitrep/` | Copy of the theme of sitrep.ch. Do not edit; update it with `scripts/sync-theme.sh` |
| `scripts/` | `sync-theme.sh`, `sync-brand.sh`, `cloudflare-build.sh`, `update-hugo.sh` |
| `wrangler.jsonc` | Cloudflare Workers configuration (static assets) |

[AGENTS.md](AGENTS.md) describes the repository in detail: the theme, the content rules, the languages and the
deployment. Read it before changing content or layouts.

## Deployment

`main` is built and deployed by Cloudflare Workers Builds to <https://f-eld.ch> (`scripts/cloudflare-build.sh`, then
`npx wrangler deploy`). Every other branch gets a preview (drafts included, `noindex`). A weekly workflow opens a
pull request when a new Hugo release is out.

## Contributing

Work on a branch and open a pull request; do not push to `main`. Titles follow
[Conventional Commits](https://www.conventionalcommits.org). Translations are drafted by us and should be reviewed by
native speakers.

## License

| What | License |
| --- | --- |
| **Code:** the theme (`themes/sitrep/`, a copy of the theme of sitrep.ch), `layouts/`, scripts, workflows and configuration | [AGPL-3.0](LICENSE), like [sitrep](https://github.com/f-eld-ch/sitrep) |
| **Content:** texts of the pages (`content/`) | [CC BY-SA 4.0](LICENSE-CONTENT). Please credit "Verein F-ELD, f-eld.ch" |
| **Font** B612 (`themes/sitrep/static/fonts/`) | SIL Open Font License 1.1 ([`LICENSE-B612.txt`](themes/sitrep/static/fonts/LICENSE-B612.txt)) |
| **Not covered:** the logos and the names F-ELD and sitrep (`static/brand/`, `themes/sitrep/static/brand/`) | Not licensed under these terms. All rights remain with the Verein F-ELD |

Questions about the association: [info@f-eld.ch](mailto:info@f-eld.ch) ·
Questions about sitrep or the service: [info@sitrep.ch](mailto:info@sitrep.ch)
