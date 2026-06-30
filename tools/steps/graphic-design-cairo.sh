#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" graphic-design.title "Out Of Thin Air")"
MODE="$(param "$SESSION" graphic-design.mode "pycairo")"
BG="$(param "$SESSION" graphic-design.bg "#4682b4")"

# Write a minimal valid SVG source (the version-controllable artifact for cairosvg mode)
cat > "$OUT/cairo.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240">
  <rect width="400" height="240" fill="$BG"/>
  <circle cx="200" cy="110" r="70" fill="#d91a1a"/>
  <text x="200" y="220" font-family="sans-serif" font-size="22" fill="white" text-anchor="middle">$TITLE</text>
</svg>
EOF
echo "  wrote out/cairo.svg"

# Write a minimal valid pycairo source script (the artifact for pycairo mode)
cat > "$OUT/cairo_draw.py" <<EOF
import cairo
s = cairo.ImageSurface(cairo.FORMAT_ARGB32, 400, 240)
c = cairo.Context(s)
c.set_source_rgb(0.27, 0.51, 0.71); c.paint()
c.set_source_rgb(0.85, 0.1, 0.1); c.arc(200, 110, 70, 0, 6.2832); c.fill()
c.set_source_rgb(1, 1, 1)
c.select_font_face("sans-serif"); c.set_font_size(22)
c.move_to(120, 220); c.show_text("$TITLE")
s.write_to_png("cairo.png")
EOF
echo "  wrote out/cairo_draw.py (mode=$MODE)"

# Graceful-degrade render to the image (PNG) deliverable
if [ "$MODE" = "pycairo" ] && python3 -c "import cairo" &>/dev/null; then
  ( cd "$OUT" && python3 cairo_draw.py ) && echo "  rendered out/cairo.png"
elif command -v cairosvg &>/dev/null; then
  cairosvg "$OUT/cairo.svg" -o "$OUT/cairo.png" && echo "  rendered out/cairo.png"
elif python3 -c "import cairosvg" &>/dev/null; then
  python3 -c "import cairosvg; cairosvg.svg2png(url='$OUT/cairo.svg', write_to='$OUT/cairo.png')" && echo "  rendered out/cairo.png"
else
  echo "  hint: brew install cairo pkg-config libffi && pip install pycairo CairoSVG, then python3 out/cairo_draw.py (or cairosvg out/cairo.svg -o out/cairo.png)"
fi
