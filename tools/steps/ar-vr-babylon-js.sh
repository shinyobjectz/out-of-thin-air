#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" ar-vr.title "OOTA Model")"
PRIMITIVE="$(param "$SESSION" ar-vr.primitive "sphere")"
DIAMETER="$(param "$SESSION" ar-vr.diameter "1")"
FORMAT="$(param "$SESSION" ar-vr.format "glb")"

cat > "$OUT/scene.mjs" <<EOF
import { NullEngine, Scene, ArcRotateCamera, HemisphericLight, MeshBuilder, Vector3 } from '@babylonjs/core';
import { GLTF2Export } from '@babylonjs/serializers';
import { writeFileSync } from 'node:fs';

const engine = new NullEngine();
const scene = new Scene(engine);
new ArcRotateCamera('cam', 1, 1, 4, Vector3.Zero(), scene);
new HemisphericLight('l', new Vector3(0, 1, 0), scene);

const p = '$PRIMITIVE', d = $DIAMETER;
if (p === 'box') MeshBuilder.CreateBox('m', { size: d }, scene);
else if (p === 'torus') MeshBuilder.CreateTorus('m', { diameter: d, thickness: d / 3 }, scene);
else if (p === 'cylinder') MeshBuilder.CreateCylinder('m', { diameter: d, height: d }, scene);
else MeshBuilder.CreateSphere('m', { diameter: d }, scene);

const name = 'model';
const res = '$FORMAT' === 'gltf'
  ? await GLTF2Export.GLTFAsync(scene, name)
  : await GLTF2Export.GLBAsync(scene, name);
const file = res.glTFFiles[name + '.$FORMAT'];
const buf = file.arrayBuffer ? Buffer.from(await file.arrayBuffer()) : Buffer.from(typeof file === 'string' ? file : JSON.stringify(file));
writeFileSync(process.argv[2] || 'model.$FORMAT', buf);
EOF
echo "  wrote out/scene.mjs ($TITLE: $PRIMITIVE)"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/@babylonjs/serializers" ]; then
  ( cd "$OUT" && node scene.mjs "model.$FORMAT" ) && echo "  rendered out/model.$FORMAT"
else
  echo "  hint: cd $OUT && npm init -y && npm pkg set type=module \\"
  echo "        && npm install @babylonjs/core @babylonjs/serializers"
  echo "  hint: then: node scene.mjs model.$FORMAT   # writes out/model.$FORMAT (magic bytes 'glTF')"
fi
