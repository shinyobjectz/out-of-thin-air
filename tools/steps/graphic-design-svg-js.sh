#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" graphic-design.title "OOTA SVG")"
WIDTH="$(param "$SESSION" graphic-design.width "200")"
HEIGHT="$(param "$SESSION" graphic-design.height "200")"
FILL="$(param "$SESSION" graphic-design.fill "#ffcc00")"

# Minimal valid SVG source (deterministic, opens in any browser/Preview).
cat > "$OUT/graphic.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="$WIDTH" height="$HEIGHT" viewBox="0 0 $WIDTH $HEIGHT">
  <title>$TITLE</title>
  <rect x="50" y="50" width="100" height="100" fill="$FILL"/>
  <circle cx="100" cy="100" r="30" fill="#3366ff"/>
</svg>
EOF
echo "  wrote out/graphic.svg"

# Graceful-degrade render via SVG.js + svgdom if Node is available.
if command -v node &>/dev/null; then
  node --input-type=module -e "
import {createSVGWindow} from 'svgdom';
import {SVG, registerWindow} from '@svgdotjs/svg.js';
import {writeFileSync} from 'fs';
const w = createSVGWindow();
registerWindow(w, w.document);
const c = SVG(w.document.documentElement);
c.size($WIDTH, $HEIGHT);
c.rect(100, 100).fill('$FILL').move(50, 50);
c.circle(60).fill('#3366ff').center(100, 100);
writeFileSync('$OUT/graphic.svg', c.svg());
" 2>/dev/null && echo "  rendered out/graphic.svg via SVG.js" \
    || echo "  hint: npm install @svgdotjs/svg.js svgdom (then re-run for SVG.js render)"
else
  echo "  hint: install Node.js + npm install @svgdotjs/svg.js svgdom to render via SVG.js"
fi
