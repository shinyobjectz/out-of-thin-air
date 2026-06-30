#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "deck.gl map")"
LON="$(param "$SESSION" maps-geo.longitude "-122.45")"
LAT="$(param "$SESSION" maps-geo.latitude "37.78")"
ZOOM="$(param "$SESSION" maps-geo.zoom "11")"
WIDTH="$(param "$SESSION" maps-geo.width "800")"
HEIGHT="$(param "$SESSION" maps-geo.height "600")"

cat > "$OUT/index.html" <<EOF
<!doctype html>
<html><head><meta charset="utf-8"><title>$TITLE</title>
<style>html,body,#c{margin:0;width:${WIDTH}px;height:${HEIGHT}px;background:#0b1021}</style>
<script src="https://unpkg.com/deck.gl@latest/dist.min.js"></script>
</head><body>
<canvas id="c" width="$WIDTH" height="$HEIGHT"></canvas>
<script>
  const {Deck, ScatterplotLayer} = deck;
  window.__done = false;
  new Deck({
    canvas: 'c',
    width: $WIDTH, height: $HEIGHT,
    initialViewState: {longitude: $LON, latitude: $LAT, zoom: $ZOOM},
    controller: false,
    layers: [new ScatterplotLayer({
      id: 'points',
      data: [{position: [$LON, $LAT]}],
      getPosition: d => d.position,
      getRadius: 1000,
      getFillColor: [255, 0, 0]
    })],
    onAfterRender: () => { window.__done = true; }
  });
</script>
</body></html>
EOF
echo "  wrote out/index.html"

cat > "$OUT/render.js" <<EOF
const puppeteer = require('puppeteer');
(async () => {
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--use-gl=swiftshader', '--no-sandbox']
  });
  const page = await browser.newPage();
  await page.setViewport({width: $WIDTH, height: $HEIGHT});
  await page.goto('file://' + __dirname + '/index.html');
  await page.waitForFunction('window.__done === true', {timeout: 30000});
  await page.screenshot({path: __dirname + '/map.png'});
  await browser.close();
})();
EOF
echo "  wrote out/render.js"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/puppeteer" ]; then
  (cd "$OUT" && node render.js) && echo "  rendered out/map.png"
else
  echo "  hint: (cd \"$OUT\" && npm install @deck.gl/core @deck.gl/layers puppeteer && node render.js) -> out/map.png"
fi
