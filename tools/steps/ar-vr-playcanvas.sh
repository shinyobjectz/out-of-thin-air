#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" ar-vr.title "PlayCanvas Scene")"
CLEAR="$(param "$SESSION" ar-vr.clear_color "#1a1a2e")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>${TITLE}</title>
<style>html,body{margin:0;height:100%;overflow:hidden}canvas{width:100%;height:100%}</style>
<script src="https://code.playcanvas.com/playcanvas-stable.min.js"></script>
</head>
<body>
<canvas id="app"></canvas>
<script>
  var canvas = document.getElementById('app');
  var app = new pc.AppBase(canvas);
  var dev = new pc.GraphicsDevice(canvas, {});
  app.init({ graphicsDevice: dev });
  app.setCanvasFillMode(pc.FILLMODE_FILL_WINDOW);
  app.setCanvasResolution(pc.RESOLUTION_AUTO);

  var hex = '${CLEAR}'.replace('#','');
  var r = parseInt(hex.substr(0,2),16)/255, g = parseInt(hex.substr(2,2),16)/255, b = parseInt(hex.substr(4,2),16)/255;

  var camera = new pc.Entity('camera');
  camera.addComponent('camera', { clearColor: new pc.Color(r, g, b) });
  camera.setPosition(0, 0, 3);
  app.root.addChild(camera);

  var light = new pc.Entity('light');
  light.addComponent('light');
  light.setEulerAngles(45, 30, 0);
  app.root.addChild(light);

  var box = new pc.Entity('box');
  box.addComponent('model', { type: 'box' });
  app.root.addChild(box);
  app.on('update', function (dt) { box.rotate(20 * dt, 30 * dt, 0); });

  app.start();
</script>
</body>
</html>
EOF
echo "  wrote out/scene.html"

if command -v npx &>/dev/null; then
  echo "  hint: capture with Playwright headless Chromium (SwiftShader software WebGL):"
  echo "    npm i -D playwright && npx playwright install chromium"
  echo "    chromium.launch({args:['--use-gl=swiftshader','--enable-unsafe-swiftshader']}); page.goto('file://$OUT/scene.html'); await page.screenshot({path:'$OUT/out.png'})"
else
  echo "  hint: install Node + npx, then: npm i -D playwright && npx playwright install chromium, then screenshot scene.html to out/out.png"
fi
