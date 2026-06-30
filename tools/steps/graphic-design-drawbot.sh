#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" graphic-design.title "OOTA")"

cat > "$OUT/scene.py" <<EOF
size(200, 200)
fill(0, 0, 1)
rect(20, 20, 160, 160)
fill(1)
fontSize(40)
text("$TITLE", (40, 90))
EOF
echo "  wrote out/scene.py"

if command -v drawbot &>/dev/null; then
  drawbot "$OUT/scene.py" "$OUT/scene.pdf" && echo "  rendered out/scene.pdf"
else
  echo "  hint: pip install drawbot-skia then drawbot out/scene.py out/scene.pdf"
fi
