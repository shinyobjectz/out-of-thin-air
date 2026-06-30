#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" ar-vr.title "A-Frame Scene")"
BOX_COLOR="$(param "$SESSION" ar-vr.box_color "#4CC3D9")"
SPHERE_COLOR="$(param "$SESSION" ar-vr.sphere_color "#EF2D5E")"
SKY_COLOR="$(param "$SESSION" ar-vr.sky_color "#ECECEC")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html>
  <head>
    <title>$TITLE</title>
    <script src="https://aframe.io/releases/1.8.0/aframe.min.js"></script>
  </head>
  <body>
    <a-scene>
      <a-box position="-1 0.5 -3" rotation="0 45 0" color="$BOX_COLOR"></a-box>
      <a-sphere position="0 1.25 -5" radius="1.25" color="$SPHERE_COLOR"></a-sphere>
      <a-sky color="$SKY_COLOR"></a-sky>
      <a-camera></a-camera>
    </a-scene>
  </body>
</html>
EOF
echo "  wrote out/scene.html"

if command -v node &>/dev/null && [ -d node_modules/puppeteer ]; then
  node -e "const p=require('puppeteer');(async()=>{const b=await p.launch({headless:'new',args:['--use-gl=angle','--enable-webgl','--ignore-gpu-blocklist']});const pg=await b.newPage();await pg.setViewport({width:800,height:600});await pg.goto('file://$OUT/scene.html');await pg.waitForFunction(()=>document.querySelector('a-scene')&&document.querySelector('a-scene').hasLoaded);await new Promise(r=>setTimeout(r,800));await pg.screenshot({path:'$OUT/out.png'});await b.close();})()" && echo "  rendered out/out.png"
else
  echo "  hint: npm install puppeteer then re-run to emit out/out.png (HTML is the canonical deliverable; render is optional)"
fi
