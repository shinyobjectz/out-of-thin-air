#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" infographics-posters.title "Riso Poster")"
COLORS="$(param "$SESSION" infographics-posters.colors "red,blue")"
SCALE="$(param "$SESSION" infographics-posters.scale "300")"

cat > "$OUT/sketch.html" <<EOF
<!doctype html>
<html><head><meta charset="utf-8"><title>$TITLE</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="https://raw.githack.com/antiboredom/p5.riso/master/lib/riso.js"></script>
</head><body><script>
function setup(){
  createCanvas($SCALE, $SCALE);
  randomSeed(1); noiseSeed(1);
  var colors = "$COLORS".split(",");
  var r = new Riso(colors[0].trim());
  r.ellipse(width/2, height/2, width*0.6, height*0.6);
  if(colors[1]){ var b = new Riso(colors[1].trim()); b.rect(width*0.2, height*0.2, width*0.3, height*0.3); }
  drawRiso();
}
</script></body></html>
EOF
echo "  wrote out/sketch.html"

if command -v node &>/dev/null && [ -d node_modules/puppeteer ]; then
  node -e "const p=require('puppeteer');(async()=>{const b=await p.launch();const pg=await b.newPage();await pg.goto('file://$OUT/sketch.html');await pg.waitForFunction(()=>document.querySelector('canvas'));const d=await pg.\$eval('canvas',c=>c.toDataURL());require('fs').writeFileSync('$OUT/poster.png',Buffer.from(d.split(',')[1],'base64'));await b.close();})()" \
    && echo "  rendered out/poster.png"
else
  echo "  hint: npm i puppeteer  then re-run to render out/poster.png from out/sketch.html in headless Chromium"
fi
