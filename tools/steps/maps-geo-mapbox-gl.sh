#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "OOTA Map")"
CENTER="$(param "$SESSION" maps-geo.center "-79.86,32.68")"
ZOOM="$(param "$SESSION" maps-geo.zoom "10")"
WIDTH="$(param "$SESSION" maps-geo.width "512")"
HEIGHT="$(param "$SESSION" maps-geo.height "256")"

# Minimal valid, self-contained MapLibre GL style (embedded GeoJSON, no tiles/token).
cat > "$OUT/style.json" <<EOF
{
  "version": 8,
  "name": "$TITLE",
  "sources": {
    "pt": {
      "type": "geojson",
      "data": {
        "type": "FeatureCollection",
        "features": [
          { "type": "Feature", "properties": {}, "geometry": { "type": "Point", "coordinates": [${CENTER}] } }
        ]
      }
    }
  },
  "layers": [
    { "id": "bg", "type": "background", "paint": { "background-color": "#0b1021" } },
    { "id": "pt", "type": "circle", "source": "pt", "paint": { "circle-radius": 8, "circle-color": "#ff5c5c" } }
  ]
}
EOF
echo "  wrote out/style.json"

if command -v mbgl-render &>/dev/null; then
  mbgl-render "$OUT/style.json" "$OUT/map.png" "$WIDTH" "$HEIGHT" -c "$CENTER" -z "$ZOOM" \
    && echo "  rendered out/map.png"
else
  echo "  hint: npm add mbgl-renderer then npx mbgl-render out/style.json out/map.png $WIDTH $HEIGHT -c $CENTER -z $ZOOM"
  echo "  hint: Linux headless prefix with 'xvfb-run -a'; Mapbox-hosted tiles need MAPBOX_ACCESS_TOKEN"
fi
