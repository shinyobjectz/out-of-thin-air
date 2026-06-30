#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "Folium Map")"
LAT="$(param "$SESSION" maps-geo.lat "37.77")"
LON="$(param "$SESSION" maps-geo.lon "-122.42")"
ZOOM="$(param "$SESSION" maps-geo.zoom "12")"
TILES="$(param "$SESSION" maps-geo.tiles "OpenStreetMap")"

cat > "$OUT/map.py" <<EOF
import folium

m = folium.Map(location=[$LAT, $LON], zoom_start=$ZOOM, tiles="$TILES")
folium.Marker(
    [$LAT, $LON],
    popup="$TITLE",
    tooltip="click",
).add_to(m)
m.save("$OUT/map.html")
print("saved map.html")
EOF
echo "  wrote out/map.py"

if command -v python3 &>/dev/null; then
  python3 "$OUT/map.py" && echo "  rendered out/map.html"
else
  echo "  hint: pip install 'folium==0.20.0' then python3 out/map.py"
fi
