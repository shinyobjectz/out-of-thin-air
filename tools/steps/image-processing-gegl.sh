#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" image-processing.title "OOTA GEGL")"
CHAIN="$(param "$SESSION" image-processing.chain "checkerboard color1='rgb(0,0,0)' color2='rgb(1,1,1)' gaussian-blur std-dev-x=4 std-dev-y=4 crop width=256 height=256")"
FORMAT="$(param "$SESSION" image-processing.format "png")"

cat > "$OUT/graph.gegl" <<EOF
$CHAIN
EOF
echo "  wrote out/graph.gegl"

if command -v gegl &>/dev/null; then
  gegl -o "$OUT/graph.$FORMAT" -- $CHAIN && echo "  rendered out/graph.$FORMAT"
else
  echo "  hint: brew install gegl  then  gegl -o out/graph.$FORMAT -- \$(cat out/graph.gegl)"
fi
