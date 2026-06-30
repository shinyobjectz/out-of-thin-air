#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" creative.title "Headless Cube")"
W="$(param "$SESSION" creative.width "256")"
H="$(param "$SESSION" creative.height "256")"
BG="$(param "$SESSION" creative.background "0x202040")"

cat > "$OUT/render.js" <<EOF
// $TITLE — headless three.js render (headless-gl path, pin three@0.124.0 + gl)
const THREE = require('three');
const createGL = require('gl');
const { PNG } = require('pngjs');
const fs = require('fs');
const W = $W, H = $H;
const canvas = { width: W, height: H, addEventListener() {}, removeEventListener() {} };
const ctx = createGL(W, H, { preserveDrawingBuffer: true });
const renderer = new THREE.WebGLRenderer({ canvas, context: ctx, antialias: false });
renderer.setSize(W, H);
const scene = new THREE.Scene();
scene.background = new THREE.Color($BG);
const cam = new THREE.PerspectiveCamera(50, W / H, 0.1, 100);
cam.position.z = 3;
const mesh = new THREE.Mesh(
  new THREE.BoxGeometry(1, 1, 1),
  new THREE.MeshStandardMaterial({ color: 0xff8800 })
);
scene.add(mesh);
mesh.rotation.set(0.6, 0.8, 0); // fixed transform — deterministic, no Date/Math.random
const l = new THREE.DirectionalLight(0xffffff, 1.2);
l.position.set(2, 3, 4);
scene.add(l);
scene.add(new THREE.AmbientLight(0xffffff, 0.4));
renderer.render(scene, cam);
const px = new Uint8Array(W * H * 4);
ctx.readPixels(0, 0, W, H, ctx.RGBA, ctx.UNSIGNED_BYTE, px);
const png = new PNG({ width: W, height: H });
for (let y = 0; y < H; y++)
  for (let x = 0; x < W * 4; x++)
    png.data[y * W * 4 + x] = px[(H - 1 - y) * W * 4 + x]; // vertical flip
png.pack().pipe(fs.createWriteStream(__dirname + '/render.png'))
  .on('finish', () => console.log('wrote render.png'));
EOF
echo "  wrote out/render.js"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/three" ]; then
  ( cd "$OUT" && node render.js ) && echo "  rendered out/render.png"
else
  echo "  hint: cd $OUT && npm init -y && npm install three@0.124.0 gl@^8 pngjs && node render.js"
fi
