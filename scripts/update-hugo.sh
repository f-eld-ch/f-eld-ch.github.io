#!/usr/bin/env bash
# Upgrade .hugo-version to the latest stable Hugo release and open a pull request.
#
#   scripts/update-hugo.sh             # used by .github/workflows/hugo-update.yaml (needs gh, git, curl)
#   scripts/update-hugo.sh --dry-run   # only check and test-build, change nothing
#
# The site is built with the new version first. If the build fails, nothing is opened and the script fails.
# An open pull request for an older release is closed when a newer release arrives.
set -euo pipefail
cd "$(dirname "$0")/.."

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

CURRENT="$(tr -d '[:space:]' < .hugo-version)"
LATEST="$(gh api repos/gohugoio/hugo/releases/latest --jq .tag_name | sed 's/^v//')"
echo "Hugo: pinned $CURRENT, latest $LATEST"

if [[ "$(printf '%s\n%s\n' "$CURRENT" "$LATEST" | sort -V | tail -1)" == "$CURRENT" ]]; then
  echo "Up to date."
  exit 0
fi

BRANCH="chore/hugo-$LATEST"
if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
  echo "Branch $BRANCH exists already."
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${LATEST}/hugo_${LATEST}_linux-amd64.tar.gz" \
  | tar -xz -C "$TMP" hugo
echo "Test build with Hugo $LATEST"
"$TMP/hugo" --gc --minify -d "$TMP/out"

if $DRY_RUN; then
  echo "Dry run: would open a pull request for Hugo $LATEST."
  exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git switch -c "$BRANCH"
echo "$LATEST" > .hugo-version
git add .hugo-version
git commit -q -m "chore: upgrade Hugo to $LATEST" -m "Automatic update from .github/workflows/hugo-update.yaml. The site built without errors with $LATEST."
git push -q origin "$BRANCH"
gh pr create --base "$(git remote show origin | sed -n 's/.*HEAD branch: //p')" --head "$BRANCH" \
  --title "chore: upgrade Hugo to $LATEST" \
  --body "Sets \`.hugo-version\` from $CURRENT to $LATEST ([release notes](https://github.com/gohugoio/hugo/releases/tag/v$LATEST)).

The site was built with $LATEST without errors (\`hugo --gc --minify\`). Check the preview of this branch before merging.

Opened by \`.github/workflows/hugo-update.yaml\`."

# a newer release replaces an older update pull request
gh pr list --state open --json number,headRefName \
  --jq '.[] | select(.headRefName | startswith("chore/hugo-")) | select(.headRefName != "'"$BRANCH"'") | .number' \
  | while read -r n; do
      gh pr close "$n" --delete-branch --comment "Replaced by the update to Hugo $LATEST."
    done
