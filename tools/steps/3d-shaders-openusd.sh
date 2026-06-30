#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" 3d-shaders.title "OOTA Cube")"
WIDTH="$(param "$SESSION" 3d-shaders.imageWidth "512")"
COMPLEXITY="$(param "$SESSION" 3d-shaders.complexity "low")"

cat > "$OUT/scene.usda" <<EOF
#usda 1.0
(
    doc = "$TITLE"
    upAxis = "Y"
    defaultPrim = "World"
)

def Xform "World"
{
    def Cube "cube"
    {
        double size = 2
    }

    def DistantLight "sun"
    {
        float inputs:intensity = 2
    }
}
EOF
echo "  wrote out/scene.usda"

# Renderer is left to the platform default (Metal on macOS, Storm/GL on Linux).
if command -v usdrecord &>/dev/null; then
  usdrecord --imageWidth "$WIDTH" --complexity "$COMPLEXITY" \
    "$OUT/scene.usda" "$OUT/scene.png" \
    && echo "  rendered out/scene.png"
else
  echo "  hint: pip install usd-core gives Python authoring ONLY (no usdrecord)."
  echo "  hint: full build => python OpenUSD/build_scripts/build_usd.py --no-tests /opt/openusd"
  echo "        export PATH=/opt/openusd/bin:\$PATH; then: usdrecord --imageWidth $WIDTH $OUT/scene.usda $OUT/scene.png"
fi
