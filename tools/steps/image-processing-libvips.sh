#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" image-processing.title "libvips")"
WIDTH="$(param "$SESSION" image-processing.width "256")"
HEIGHT="$(param "$SESSION" image-processing.height "256")"
COLOUR="$(param "$SESSION" image-processing.colour "#3366cc")"

# Minimal valid source: a portable PPM (P3) raster the right kind, no deps.
# Parse hex colour -> R G B
HEX="${COLOUR#\#}"
R=$((16#${HEX:0:2})); G=$((16#${HEX:2:2})); B=$((16#${HEX:4:2}))

SRC="$OUT/libvips.ppm"
{
  echo "P3"
  echo "$WIDTH $HEIGHT"
  echo "255"
  total=$((WIDTH * HEIGHT))
  i=0
  while [ "$i" -lt "$total" ]; do
    echo "$R $G $B"
    i=$((i + 1))
  done
} > "$SRC"
echo "  wrote out/libvips.ppm"

if command -v vips &>/dev/null; then
  vips colourspace "$SRC" "$OUT/libvips.png" srgb && echo "  rendered out/libvips.png"
  command -v vipsheader &>/dev/null && vipsheader "$OUT/libvips.png" || true
else
  echo "  hint: brew install vips  then  vips colourspace out/libvips.ppm out/libvips.png srgb"
fi
