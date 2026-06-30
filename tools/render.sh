#!/usr/bin/env bash
# npm install + remotion render for a session's out/ scaffold.
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="${1:?usage: render.sh <slug>}"
OUT="$PROJECT/cli/sessions/$SLUG/out"

if [[ ! -f "$OUT/package.json" ]]; then
  echo "error: no Remotion scaffold at $OUT — run oota run $SLUG first" >&2
  exit 1
fi

cd "$OUT"
if [[ ! -d node_modules ]]; then
  echo "→ npm install"
  npm install
fi

echo "→ npm run render"
npm run render
ls -lh out/*.mp4 2>/dev/null || ls -lh *.mp4 2>/dev/null || true
