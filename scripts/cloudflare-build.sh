#!/usr/bin/env bash
# Build script for Cloudflare Workers Builds (static assets). Same as for sitrep.ch.
#
#   Build command:    scripts/cloudflare-build.sh
#   Deploy command:   npx wrangler deploy
#   Preview command:  npx wrangler preview     (non-production branches)
#
# wrangler.jsonc serves the output directory (public/) as static assets.
#
# The Hugo version comes from .hugo-version (single source of truth, also used by the GitHub
# Actions workflow). If the installed Hugo differs, the exact release is downloaded, so no
# version has to be kept in sync in the Cloudflare dashboard.
#
# WORKERS_CI_BRANCH is set by Cloudflare. The production branch (main) is built like the
# GitHub Actions workflow. Every other branch is a preview: it includes drafts and is marked
# noindex. The preview URL is not known at build time, so baseURL stays as configured
# (relativeURLs keeps links and assets working on any host).
set -euo pipefail

cd "$(dirname "$0")/.."

WANT="$(tr -d '[:space:]' < .hugo-version)"
HAVE="$(hugo version 2>/dev/null | sed -n 's/^hugo v\([0-9.]*\).*/\1/p' || true)"
if [[ "$HAVE" != "$WANT" ]]; then
  echo "Hugo ${HAVE:-not installed}, need $WANT: downloading"
  TMP="$(mktemp -d)"
  curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${WANT}/hugo_${WANT}_linux-amd64.tar.gz" \
    | tar -xz -C "$TMP" hugo
  export PATH="$TMP:$PATH"
fi
hugo version

BRANCH="${WORKERS_CI_BRANCH:-main}"
DEST="${OUTPUT_DIR:-public}"

if [[ "$BRANCH" == "main" ]]; then
  echo "Building production ($BRANCH)"
  hugo --gc --minify -d "$DEST"
else
  echo "Building preview ($BRANCH)"
  hugo --gc --minify --buildDrafts -d "$DEST"
  # Keep previews out of search engines (served by Workers static assets).
  printf '/*\n  X-Robots-Tag: noindex, nofollow\n' > "$DEST/_headers"
fi
