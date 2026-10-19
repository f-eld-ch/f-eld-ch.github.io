#!/usr/bin/env bash
# Copy the F-ELD lockups from the (private) f-eld-ch/brand repo. The files are stored under the names
# of the theme's lockups (lockup-blue.svg, ...), so they override the sitrep.ch logo in the theme.
# Usage: scripts/sync-brand.sh [path-to-brand-checkout]   (default: ../brand)
set -euo pipefail
BRAND="${1:-$(dirname "$0")/../../brand}"
DEST="$(dirname "$0")/../static/brand"
[[ -f "$BRAND/logo/feld-lockup-blue.svg" ]] || { echo "F-ELD lockups not found in $BRAND/logo" >&2; exit 1; }
mkdir -p "$DEST"
for v in blue white on-paper on-ink; do
  cp "$BRAND/logo/feld-lockup-$v.svg" "$DEST/lockup-$v.svg"
done
echo "synced F-ELD lockups from brand $(git -C "$BRAND" rev-parse --short HEAD) -> $DEST"
