#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" comics-illustration.title "Comic Panel")"
NAME="$(param "$SESSION" comics-illustration.name "ava")"
ANGLE="$(param "$SESSION" comics-illustration.angle "front")"
EMOTION="$(param "$SESSION" comics-illustration.emotion "cry")"
POSE="$(param "$SESSION" comics-illustration.pose "angry")"
DIALOGUE="$(param "$SESSION" comics-illustration.dialogue "...")"

# minimal valid SVG placeholder (composed panel frame + author dialogue);
# replaced by real comicgen output when the npm module is available.
cat > "$OUT/comic.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="300" viewBox="0 0 400 300">
  <rect x="0" y="0" width="400" height="300" fill="#ffffff" stroke="#222" stroke-width="2"/>
  <text x="200" y="30" text-anchor="middle" font-family="sans-serif" font-size="18" fill="#222">$TITLE</text>
  <text x="200" y="150" text-anchor="middle" font-family="sans-serif" font-size="14" fill="#888">$NAME / $ANGLE / $EMOTION / $POSE</text>
  <rect x="60" y="200" width="280" height="60" rx="12" fill="#f4f4f4" stroke="#222"/>
  <text x="200" y="235" text-anchor="middle" font-family="sans-serif" font-size="13" fill="#222">$DIALOGUE</text>
</svg>
EOF
echo "  wrote out/comic.svg"

if command -v node &>/dev/null && node -e "require('comicgen')" &>/dev/null; then
  node -e "const c=require('comicgen'); const fs=require('fs'); const svg=c({name:'$NAME',angle:'$ANGLE',emotion:'$EMOTION',pose:'$POSE'}); fs.writeFileSync('$OUT/comic.svg', svg);" \
    && echo "  rendered out/comic.svg (comicgen)"
  if command -v npx &>/dev/null; then
    npx --no-install resvg-js "$OUT/comic.svg" "$OUT/comic.png" &>/dev/null \
      && echo "  rendered out/comic.png (resvg-js)" || true
  fi
else
  echo "  hint: npm install comicgen  then  node -e \"const c=require('comicgen');require('fs').writeFileSync('out/comic.svg',c({name:'$NAME',angle:'$ANGLE',emotion:'$EMOTION',pose:'$POSE'}))\""
fi
