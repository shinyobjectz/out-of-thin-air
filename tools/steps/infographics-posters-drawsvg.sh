#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" infographics-posters.title "OOTA")"

cat > "$OUT/build.py" <<EOF
import drawsvg as draw

d = draw.Drawing(400, 200, origin='center')
d.append(draw.Rectangle(-200, -100, 400, 200, fill='#ffffff'))
d.append(draw.Circle(0, 10, 50, fill='#e2467a', stroke='#1a1a1a', stroke_width=3))
d.append(draw.Text("${TITLE}", 28, 0, -60, center=True, fill='#1a1a1a'))
d.save_svg("$OUT/poster.svg")
print("wrote $OUT/poster.svg")
EOF
echo "  wrote out/build.py"

if command -v python3 &>/dev/null && python3 -c "import drawsvg" &>/dev/null; then
  python3 "$OUT/build.py" && echo "  rendered out/poster.svg"
else
  echo "  hint: python3 -m pip install \"drawsvg~=2.0\" then python3 out/build.py"
fi
