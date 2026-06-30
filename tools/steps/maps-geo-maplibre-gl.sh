#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "MapLibre Map")"
CENTER="$(param "$SESSION" maps-geo.center "0,0")"
ZOOM="$(param "$SESSION" maps-geo.zoom "0")"
WIDTH="$(param "$SESSION" maps-geo.width "512")"
HEIGHT="$(param "$SESSION" maps-geo.height "512")"
BG="$(param "$SESSION" maps-geo.bg "#1d6fb8")"
RATIO="$(param "$SESSION" maps-geo.ratio "1")"

mkdir -p "$OUT/src"

# minimal valid MapLibre GL style (version 8) — self-contained, offline,
# deterministic: a single background layer, no remote sources.
cat > "$OUT/src/style.json" <<EOF
{
  "version": 8,
  "name": "${TITLE}",
  "sources": {},
  "layers": [
    { "id": "bg", "type": "background", "paint": { "background-color": "${BG}" } }
  ]
}
EOF

# interactive HTML deliverable (alternate kind) using the same style
LON="${CENTER%%,*}"
LAT="${CENTER##*,}"
cat > "$OUT/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${TITLE}</title>
  <link href="https://unpkg.com/maplibre-gl@5/dist/maplibre-gl.css" rel="stylesheet">
  <script src="https://unpkg.com/maplibre-gl@5/dist/maplibre-gl.js"></script>
  <style>html,body,#map{margin:0;height:100%;width:100%}</style>
</head>
<body>
  <div id="map"></div>
  <script>
    fetch('src/style.json').then(r => r.json()).then(style => {
      new maplibregl.Map({
        container: 'map',
        style: style,
        center: [${LON}, ${LAT}],
        zoom: ${ZOOM}
      });
    });
  </script>
</body>
</html>
EOF

echo "  wrote out/src/style.json"
echo "  wrote out/index.html"

# graceful render: headless PNG via GL Native + sharp if available, else hint
if node -e "require.resolve('@maplibre/maplibre-gl-native');require.resolve('sharp')" &>/dev/null; then
  node -e "const mbgl=require('@maplibre/maplibre-gl-native');const sharp=require('sharp');const fs=require('fs');const style=JSON.parse(fs.readFileSync('${OUT}/src/style.json','utf8'));const W=${WIDTH},H=${HEIGHT};const map=new mbgl.Map({ratio:${RATIO}});map.load(style);map.render({width:W,height:H,zoom:${ZOOM},center:[${LON},${LAT}]},(e,buf)=>{if(e)throw e;map.release();sharp(buf,{raw:{width:W*${RATIO},height:H*${RATIO},channels:4}}).toFile('${OUT}/map.png',x=>{if(x)throw x;process.exit(0);});});" \
    && echo "  rendered out/map.png"
else
  echo "  hint: npm i @maplibre/maplibre-gl-native sharp then re-run this step for a headless PNG; or open out/index.html in a browser"
fi
