#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" image-processing.title "Out Of Thin Air")"
PIPELINE="$(param "$SESSION" image-processing.pipeline "fx_freaky_details 2,10,1,11,0,32,0")"
SEED="$(param "$SESSION" image-processing.seed "42")"
BG="$(param "$SESSION" image-processing.bg "255,128,0")"

# Write the version-controllable artifact: a G'MIC recipe (pipeline) script.
# Synthesizes a 64x64 RGB image from scratch, seeded for determinism, then
# applies the chosen pipeline. The .gmic recipe is the source; the .png is the deliverable.
cat > "$OUT/recipe.gmic" <<EOF
# $TITLE — G'MIC recipe (deterministic; srand seeds any stochastic filter)
64,64,1,3
fill_color $BG
srand $SEED
$PIPELINE
EOF
echo "  wrote out/recipe.gmic"

# Graceful-degrade render to the image (PNG) deliverable.
if command -v gmic &>/dev/null; then
  gmic "$OUT/recipe.gmic" -o "$OUT/gmic.png" && echo "  rendered out/gmic.png"
else
  echo "  hint: brew install gmic, then gmic out/recipe.gmic -o out/gmic.png"
fi
