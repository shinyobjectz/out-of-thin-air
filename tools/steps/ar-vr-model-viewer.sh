#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" ar-vr.title "model-viewer scene")"
SRC="$(param "$SESSION" ar-vr.src "astronaut.glb")"
ORBIT="$(param "$SESSION" ar-vr.camera_orbit "30deg 75deg 4m")"
EXPOSURE="$(param "$SESSION" ar-vr.exposure "1")"
BG="$(param "$SESSION" ar-vr.background "#111111")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>$TITLE</title>
<script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/4.0.0/model-viewer.min.js"></script>
<style>html,body,model-viewer{width:600px;height:600px;margin:0;background:$BG}</style>
</head>
<body>
<model-viewer id="mv" src="$SRC" camera-controls exposure="$EXPOSURE" camera-orbit="$ORBIT" interaction-prompt="none"></model-viewer>
</body>
</html>
EOF
echo "  wrote out/scene.html"

# graceful-degrade: render a deterministic PNG poster via headless Chromium (Puppeteer)
cat > "$OUT/shoot.mjs" <<'EOF'
import puppeteer from 'puppeteer';
const dir = new URL('.', import.meta.url).pathname;
const b = await puppeteer.launch({headless:'new'});
const p = await b.newPage();
await p.setViewport({width:600,height:600,deviceScaleFactor:2});
await p.goto('file://' + dir + 'scene.html');
await p.waitForFunction(() => { const m=document.getElementById('mv'); return m && m.loaded===true; }, {timeout:30000});
const el = await p.$('#mv');
await el.screenshot({path: dir + 'out.png'});
await b.close();
console.log('wrote out/out.png');
EOF

if command -v node &>/dev/null && [ -d "$OUT/node_modules/puppeteer" ]; then
  ( cd "$OUT" && node shoot.mjs ) && echo "  rendered out/out.png"
else
  echo "  hint: cd $OUT && npm init -y && npm install puppeteer, then node shoot.mjs to render out/out.png"
fi
