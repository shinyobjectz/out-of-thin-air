#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" data-visualization.title "OOTA gnuplot plot")"

cat > "$OUT/plot.gp" <<EOF
set terminal svg size 640,480
set output 'plot.svg'
set title "$TITLE"
set grid
plot [-10:10] sin(x) with lines title "sin(x)"
EOF
echo "  wrote out/plot.gp"

if command -v gnuplot &>/dev/null; then
  ( cd "$OUT" && gnuplot plot.gp ) && echo "  rendered out/plot.svg"
else
  echo "  hint: brew install gnuplot then gnuplot plot.gp"
fi
