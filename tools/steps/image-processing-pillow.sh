#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" image-processing.title "Out Of Thin Air")"
WIDTH="$(param "$SESSION" image-processing.width "800")"
HEIGHT="$(param "$SESSION" image-processing.height "400")"
BG="$(param "$SESSION" image-processing.bg "#1e293b")"
FG="$(param "$SESSION" image-processing.fg "#38bdf8")"

cat > "$OUT/render.py" <<EOF
from PIL import Image, ImageDraw

W, H = ${WIDTH}, ${HEIGHT}
img = Image.new("RGB", (W, H), "${BG}")
d = ImageDraw.Draw(img)
d.rectangle([20, 20, W - 20, H - 20], outline="${FG}", width=3)
d.text((40, 40), "${TITLE}", fill="${FG}")
img.save("${OUT}/out.png")
EOF
echo "  wrote out/render.py"

if command -v python3 &>/dev/null && python3 -c "import PIL" &>/dev/null; then
  python3 "$OUT/render.py" && echo "  rendered out/out.png"
else
  echo "  hint: pip install pillow then python3 $OUT/render.py"
fi
