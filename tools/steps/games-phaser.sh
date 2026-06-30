#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" games.title "Thin Air")"
CDN="$(param "$SESSION" games.cdn "phaser@4.2.1")"

cat > "$OUT/index.html" <<EOF
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>${TITLE}</title>
  <script src="https://cdn.jsdelivr.net/npm/${CDN}/dist/phaser.min.js"></script>
  <style>html,body{margin:0;background:#101018}</style>
</head>
<body>
<script>
class MainScene extends Phaser.Scene {
  create() {
    this.add.rectangle(400, 300, 240, 140, 0x4f8cff);
    this.add.text(400, 300, "${TITLE}", { fontSize: "28px", color: "#ffffff" })
      .setOrigin(0.5);
  }
}
new Phaser.Game({
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  backgroundColor: "#101018",
  scene: MainScene
});
</script>
</body>
</html>
EOF
echo "  wrote out/index.html"

if command -v node &>/dev/null && [ -f node_modules/.bin/playwright -o -d node_modules/playwright ]; then
  node -e "const{chromium}=require('playwright');(async()=>{const b=await chromium.launch();const p=await b.newPage();await p.goto('file://'+process.cwd()+'/$OUT/index.html');await p.waitForTimeout(1000);await p.screenshot({path:'$OUT/out.png'});await b.close();})()" \
    && echo "  rendered out/out.png"
else
  echo "  hint: npm install playwright && npx playwright install chromium, then snapshot out/index.html headlessly to out/out.png"
fi
