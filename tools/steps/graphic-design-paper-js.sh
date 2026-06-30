#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" graphic-design.title "Paper.js")"
WIDTH="$(param "$SESSION" graphic-design.width "400")"
HEIGHT="$(param "$SESSION" graphic-design.height "400")"
FILL="$(param "$SESSION" graphic-design.fill "#ff6347")"

cat > "$OUT/scene.js" <<EOF
const paper = require('paper-jsdom');
const fs = require('fs');
paper.setup(new paper.Size($WIDTH, $HEIGHT));
new paper.Path.Circle({
  center: [$WIDTH / 2, $HEIGHT / 2],
  radius: Math.min($WIDTH, $HEIGHT) * 0.4,
  fillColor: '$FILL'
});
new paper.PointText({
  point: [$WIDTH / 2, $HEIGHT - 20],
  content: '$TITLE',
  fillColor: 'black',
  justification: 'center',
  fontSize: 16
});
fs.writeFileSync(process.argv[1], paper.project.exportSVG({ asString: true }));
EOF
echo "  wrote out/scene.js"

# Minimal valid placeholder SVG so the artifact is renderable even without Node deps.
cat > "$OUT/paper-js.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="$WIDTH" height="$HEIGHT" viewBox="0,0,$WIDTH,$HEIGHT">
  <circle cx="$((WIDTH/2))" cy="$((HEIGHT/2))" r="$((WIDTH/3))" fill="$FILL"/>
  <text x="$((WIDTH/2))" y="$((HEIGHT-20))" font-size="16" text-anchor="middle" fill="black">$TITLE</text>
</svg>
EOF
echo "  wrote out/paper-js.svg"

if command -v node &>/dev/null && [ -d node_modules/paper-jsdom ]; then
  node "$OUT/scene.js" "$OUT/paper-js.svg" && echo "  rendered out/paper-js.svg via paper-jsdom"
else
  echo "  hint: npm install paper-jsdom@0.12.18 then node $OUT/scene.js $OUT/paper-js.svg"
fi
