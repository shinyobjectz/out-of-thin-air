#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" textiles.title "Stitched Square")"
SHAPE="$(param "$SESSION" textiles.shape "square")"
SIZE="$(param "$SESSION" textiles.size "200")"
STITCH_LENGTH="$(param "$SESSION" textiles.stitch_length "30")"
COLOR="$(param "$SESSION" textiles.color "#000000")"
EXPORT_FORMAT="$(param "$SESSION" textiles.export_format "dst")"

# sides per shape
case "$SHAPE" in
  triangle) SIDES=3 ;;
  hexagon)  SIDES=6 ;;
  star)     SIDES=5 ;;
  *)        SIDES=4 ;;
esac

# minimal valid TurtleThread program (the code-driven equivalent of TurtleStitch)
cat > "$OUT/pattern.py" <<EOF
# $TITLE
import turtlethread

t = turtlethread.Turtle()
sides = $SIDES
size = $SIZE
angle = 360 / sides
with t.running_stitch($STITCH_LENGTH):
    for _ in range(sides):
        t.forward(size)
        t.right(angle)

t.save("pattern.svg")          # vector preview (artifact kind: svg)
t.save("pattern.$EXPORT_FORMAT")  # embroidery-machine file
print("saved pattern.svg and pattern.$EXPORT_FORMAT")
EOF
echo "  wrote out/pattern.py (shape=$SHAPE sides=$SIDES color=$COLOR)"

# graceful render: run TurtleThread headless if available, else print install hint
if ./venv/bin/python -c "import turtlethread" &>/dev/null; then
  ( cd "$OUT" && "$OLDPWD/venv/bin/python" pattern.py ) && echo "  rendered out/pattern.svg + out/pattern.$EXPORT_FORMAT"
elif python3 -c "import turtlethread" &>/dev/null; then
  ( cd "$OUT" && python3 pattern.py ) && echo "  rendered out/pattern.svg + out/pattern.$EXPORT_FORMAT"
else
  echo "  hint: python3 -m venv venv && ./venv/bin/pip install turtlethread"
  echo "        then: ./venv/bin/python $OUT/pattern.py"
fi
