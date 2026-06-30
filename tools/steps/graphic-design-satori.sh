#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" graphic-design.title "Out Of Thin Air")"
BG="$(param "$SESSION" graphic-design.bg "#0b1021")"
FG="$(param "$SESSION" graphic-design.fg "#ffffff")"
WIDTH="$(param "$SESSION" graphic-design.width "600")"
HEIGHT="$(param "$SESSION" graphic-design.height "315")"

# Minimal valid Satori component: a single inline-CSS HTML string (satori-html VNode).
cat > "$OUT/card.html" <<EOF
<div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:${BG};color:${FG};font-size:48px;font-family:Inter">${TITLE}</div>
EOF
echo "  wrote out/card.html"

# Render driver: HTML string -> deterministic SVG (primary), then optional SVG -> PNG.
cat > "$OUT/render.mjs" <<'EOF'
import fs from 'node:fs';
import satori from 'satori';
import { html } from 'satori-html';
const [markupPath, w, h, fontPath] = process.argv.slice(2);
const markup = html(fs.readFileSync(markupPath, 'utf8'));
const svg = await satori(markup, {
  width: Number(w), height: Number(h),
  fonts: [{ name: 'Inter', data: fs.readFileSync(fontPath), weight: 400, style: 'normal' }],
});
fs.writeFileSync('card.svg', svg);
try {
  const { Resvg } = await import('@resvg/resvg-js');
  fs.writeFileSync('card.png', new Resvg(svg).render().asPng());
  console.log('  rendered out/card.svg + out/card.png');
} catch {
  console.log('  rendered out/card.svg (install @resvg/resvg-js for PNG)');
}
EOF

if command -v node &>/dev/null && [ -f "$OUT/Inter-Regular.ttf" ]; then
  ( cd "$OUT" && node render.mjs card.html "$WIDTH" "$HEIGHT" Inter-Regular.ttf )
else
  echo "  hint: npm install satori satori-html @resvg/resvg-js && drop a TTF at out/Inter-Regular.ttf, then: node out/render.mjs out/card.html $WIDTH $HEIGHT out/Inter-Regular.ttf"
fi
