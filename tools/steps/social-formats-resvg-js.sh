#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" social-formats.title "OOTA")"
BG="$(param "$SESSION" social-formats.background "#0af")"
FIT_VALUE="$(param "$SESSION" social-formats.fit_value "1200")"

cat > "$OUT/card.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="600" height="315">
  <rect width="600" height="315" fill="${BG}"/>
  <text x="40" y="170" font-size="48" fill="#ffffff" font-family="sans-serif">${TITLE}</text>
</svg>
EOF
echo "  wrote out/card.svg"

if command -v node &>/dev/null && node -e "require.resolve('@resvg/resvg-js')" &>/dev/null; then
  node --input-type=module <<EOF && echo "  rendered out/card.png"
import { Resvg } from '@resvg/resvg-js';
import { readFileSync, writeFileSync } from 'node:fs';
const svg = readFileSync('${OUT}/card.svg');
const r = new Resvg(svg, { fitTo: { mode: 'width', value: ${FIT_VALUE} }, font: { loadSystemFonts: false } });
writeFileSync('${OUT}/card.png', r.render().asPng());
EOF
else
  echo "  hint: npm i @resvg/resvg-js  then  node -e \"...new Resvg(svg).render().asPng()...\" to rasterize out/card.svg -> out/card.png"
fi
