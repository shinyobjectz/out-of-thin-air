#!/usr/bin/env bash
# Instantiate a code-as session pre-wired to a single <category>: <tool> chain.
# Usage: scaffold.sh <category> <tool> "<title>"
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
CAT="${1:?usage: scaffold.sh <category> <tool> \"<title>\"}"
TOOL="${2:?usage: scaffold.sh <category> <tool> \"<title>\"}"
TITLE="${3:-$TOOL session}"
slug="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
dir="$PROJECT/cli/sessions/$slug"
if [[ -e "$dir" ]]; then echo "exists: $dir" >&2; exit 1; fi
mkdir -p "$dir/out"
cat > "$dir/session.work" <<EOF
# $TITLE

card do
  board: "code-as"
  status: "draft"
  slug: "$slug"
end

## Requirements

_Describe what you are making._

chain do
  $CAT: $TOOL
end

params do
  $CAT.title: "$TITLE"
end
EOF
echo "created $dir/session.work ($CAT: $TOOL)"
echo "run:  oota run $slug"
echo "open: oota open $slug   (after oota serve)"
