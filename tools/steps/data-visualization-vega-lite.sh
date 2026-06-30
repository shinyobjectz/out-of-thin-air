#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" data-visualization.title "Sample Chart")"
VL_VERSION="$(param "$SESSION" data-visualization.vl_version "5.20")"
SCALE="$(param "$SESSION" data-visualization.scale "2")"

cat > "$OUT/chart.vl.json" <<EOF
{
  "\$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "title": "$TITLE",
  "data": {"values": [
    {"a": "A", "b": 28},
    {"a": "B", "b": 55},
    {"a": "C", "b": 43}
  ]},
  "mark": "bar",
  "encoding": {
    "x": {"field": "a", "type": "nominal"},
    "y": {"field": "b", "type": "quantitative"}
  }
}
EOF
echo "  wrote out/chart.vl.json"

if command -v vl-convert &>/dev/null; then
  vl-convert vl2png -i "$OUT/chart.vl.json" -o "$OUT/chart.png" --vl-version "$VL_VERSION" --scale "$SCALE" \
    && echo "  rendered out/chart.png"
else
  echo "  hint: cargo install vl-convert --locked  (or pip install vl-convert-python)"
  echo "        then: vl-convert vl2png -i out/chart.vl.json -o out/chart.png --vl-version $VL_VERSION --scale $SCALE"
fi
