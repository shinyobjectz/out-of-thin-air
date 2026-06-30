#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" image-processing.title "Out Of Thin Air")"
SIZE="$(param "$SESSION" image-processing.size "200x100")"
BG="$(param "$SESSION" image-processing.bg "navy")"
FORMAT="$(param "$SESSION" image-processing.format "png")"

# Minimal valid markup source (MSL XML) — version-controllable, diffable.
cat > "$OUT/image.msl" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<image>
  <read filename="gradient:${BG}-white"/>
  <resize geometry="${SIZE}"/>
  <write filename="${OUT}/image.${FORMAT}"/>
</image>
EOF
echo "  wrote out/image.msl"

# Deterministic render via the magick CLI pipeline (MSL/conjure broken on IM7).
if command -v magick &>/dev/null; then
  magick -size "$SIZE" "gradient:${BG}-white" \
    -draw "fill red circle 100,50 100,20" -strip "$OUT/image.${FORMAT}" \
    && echo "  rendered out/image.${FORMAT}"
  magick identify "$OUT/image.${FORMAT}" || true
else
  echo "  hint: brew install imagemagick then magick -size $SIZE gradient:${BG}-white -strip out/image.${FORMAT}"
fi
