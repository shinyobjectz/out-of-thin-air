#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "Leaflet Map")"
LAT="$(param "$SESSION" maps-geo.lat "37.7749")"
LNG="$(param "$SESSION" maps-geo.lng "-122.4194")"
ZOOM="$(param "$SESSION" maps-geo.zoom "12")"
POPUP="$(param "$SESSION" maps-geo.marker_popup "Marker")"

# Minimal valid self-contained Leaflet HTML against a pinned CDN.
cat > "$OUT/map.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${TITLE}</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<style>html,body{margin:0;height:100%}#map{height:100%}</style>
</head>
<body>
<div id="map"></div>
<script>
  var map = L.map('map').setView([${LAT}, ${LNG}], ${ZOOM});
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap contributors'
  }).addTo(map);
  L.marker([${LAT}, ${LNG}]).addTo(map).bindPopup('${POPUP}');
</script>
</body>
</html>
EOF
echo "  wrote out/map.html"

# Optional deterministic rebuild via folium (Python), if available.
if command -v python3 &>/dev/null && python3 -c "import folium" &>/dev/null; then
  python3 -c "import folium; m=folium.Map(location=[${LAT},${LNG}], zoom_start=${ZOOM}); folium.Marker([${LAT},${LNG}], popup='${POPUP}').add_to(m); m.save('$OUT/map.html')" && echo "  rendered out/map.html via folium"
else
  echo "  hint: pip install folium  then  python3 -c \"import folium; m=folium.Map(location=[${LAT},${LNG}], zoom_start=${ZOOM}); folium.Marker([${LAT},${LNG}], popup='${POPUP}').add_to(m); m.save('$OUT/map.html')\""
fi
