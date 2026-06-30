#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" ar-vr.title "Box")"
FMT="$(param "$SESSION" ar-vr.output_format "usdz")"

# Minimal VALID glTF 2.0 source (single triangle) — the deterministic, version-controllable input.
cat > "$OUT/model.gltf" <<'EOF'
{
  "asset": { "version": "2.0", "generator": "OOTA usd-from-gltf step" },
  "scene": 0,
  "scenes": [ { "nodes": [ 0 ] } ],
  "nodes": [ { "mesh": 0, "name": "tri" } ],
  "meshes": [ { "primitives": [ { "attributes": { "POSITION": 0 }, "indices": 1 } ] } ],
  "buffers": [ { "byteLength": 42, "uri": "data:application/octet-stream;base64,AAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAQAC" } ],
  "bufferViews": [
    { "buffer": 0, "byteOffset": 0, "byteLength": 36, "target": 34962 },
    { "buffer": 0, "byteOffset": 36, "byteLength": 6, "target": 34963 }
  ],
  "accessors": [
    { "bufferView": 0, "componentType": 5126, "count": 3, "type": "VEC3", "min": [0,0,0], "max": [1,1,0] },
    { "bufferView": 1, "componentType": 5123, "count": 3, "type": "SCALAR" }
  ]
}
EOF
echo "  wrote out/model.gltf (title: $TITLE)"

# Graceful-degrade render: convert glTF -> USD via UFG (Docker), else print hint.
if command -v docker &>/dev/null; then
  docker run --rm -v "$OUT":/usr/app leon/usd-from-gltf:latest model.gltf "model.$FMT" \
    && echo "  rendered out/model.$FMT" \
    || echo "  hint: docker present but UFG run failed — check stderr warnings (unsupported glTF extensions warn, not fail)"
else
  echo "  hint: docker pull leon/usd-from-gltf:latest then docker run --rm -v \"\$PWD\":/usr/app leon/usd-from-gltf:latest model.gltf model.$FMT"
fi

# Optional text inspection / validation if Pixar USD tools are present.
if command -v usdcat &>/dev/null && [ -f "$OUT/model.$FMT" ]; then
  usdcat "$OUT/model.$FMT" > "$OUT/model.usda" && echo "  wrote out/model.usda (text snapshot)"
fi
