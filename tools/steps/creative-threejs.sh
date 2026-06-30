#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" creative.title "three.js scene")"
BG="$(param "$SESSION" creative.bg "#101014")"
CUBE_COLOR="$(param "$SESSION" creative.cube_color "#22cc88")"
FOV="$(param "$SESSION" creative.fov "60")"
WIDTH="$(param "$SESSION" creative.width "640")"
HEIGHT="$(param "$SESSION" creative.height "480")"
CONTROLS="$(param "$SESSION" creative.controls "true")"
ANIMATE="$(param "$SESSION" creative.animate "true")"
ANTIALIAS="$(param "$SESSION" creative.antialias "true")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${TITLE}</title>
<style>html,body{margin:0;height:100%;background:${BG};overflow:hidden}canvas{display:block}</style>
<script type="importmap">
{ "imports": {
  "three": "https://unpkg.com/three@0.169.0/build/three.module.js",
  "three/addons/": "https://unpkg.com/three@0.169.0/examples/jsm/"
}}
</script>
</head>
<body>
<script type="module">
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

const W = ${WIDTH}, H = ${HEIGHT};
const renderer = new THREE.WebGLRenderer({ antialias: ${ANTIALIAS} });
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.setSize(W, H);
document.body.appendChild(renderer.domElement);

const scene = new THREE.Scene();
scene.background = new THREE.Color('${BG}');

const camera = new THREE.PerspectiveCamera(${FOV}, W / H, 0.1, 100);
camera.position.set(2.5, 2, 3.5);

scene.add(new THREE.AmbientLight(0xffffff, 0.5));
const key = new THREE.DirectionalLight(0xffffff, 1.2);
key.position.set(5, 8, 4);
scene.add(key);

const cube = new THREE.Mesh(
  new THREE.BoxGeometry(1.5, 1.5, 1.5),
  new THREE.MeshStandardMaterial({ color: '${CUBE_COLOR}', roughness: 0.4, metalness: 0.1 })
);
scene.add(cube);

let controls = null;
if (${CONTROLS}) { controls = new OrbitControls(camera, renderer.domElement); controls.enableDamping = true; }

function render() {
  if (${ANIMATE}) { cube.rotation.x += 0.01; cube.rotation.y += 0.013; }
  if (controls) controls.update();
  renderer.render(scene, camera);
}
if (${ANIMATE}) { renderer.setAnimationLoop(render); } else { render(); }
</script>
</body>
</html>
EOF
echo "  wrote out/scene.html"

# graceful render: capture a PNG via headless Chrome if puppeteer is installed
if command -v node &>/dev/null && node -e "require.resolve('puppeteer')" &>/dev/null; then
  node -e "const p=require('puppeteer');(async()=>{const b=await p.launch({headless:'new',args:['--use-gl=angle','--enable-unsafe-swiftshader']});const pg=await b.newPage();await pg.goto('file://${OUT}/scene.html');await new Promise(r=>setTimeout(r,1500));await pg.screenshot({path:'${OUT}/scene.png'});await b.close();})()" \
    && echo "  rendered out/scene.png"
else
  echo "  hint: npm install puppeteer three, then node -e \"...page.screenshot({path:'out/scene.png'})...\" (see wrapper Render block). Or just open out/scene.html in a browser."
fi
