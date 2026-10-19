#!/usr/bin/env bash
# Copy the theme from the sitrep.ch website so that both sites keep the same design.
# Usage: scripts/sync-theme.sh [path-to-sitrep.ch-checkout]   (default: ../sitrep.ch)
# Site specific changes live in ./layouts and ./static (they override the theme), never in themes/sitrep.
set -euo pipefail
SRC="${1:-$(dirname "$0")/../../sitrep.ch}"
DEST="$(dirname "$0")/../themes/sitrep"
[[ -f "$SRC/themes/sitrep/theme.toml" ]] || { echo "sitrep.ch checkout not found at $SRC" >&2; exit 1; }
rm -rf "$DEST" && cp -r "$SRC/themes/sitrep" "$DEST"
echo "synced theme $(git -C "$SRC" rev-parse --short HEAD) -> $DEST"
