#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" maps-geo.title "kepler.gl map")"
LAT="$(param "$SESSION" maps-geo.lat "37.77")"
LNG="$(param "$SESSION" maps-geo.lng "-122.42")"
ZOOM="$(param "$SESSION" maps-geo.zoom "9")"

# minimal valid data source: CSV of points
cat > "$OUT/data.csv" <<EOF
lat,lng,val
37.77,-122.42,1
40.71,-74.0,2
34.05,-118.24,3
EOF
echo "  wrote out/data.csv"

# minimal valid kepler.gl JSON config (viewport pinned for determinism)
cat > "$OUT/config.json" <<EOF
{
  "version": "v1",
  "config": {
    "mapState": { "latitude": $LAT, "longitude": $LNG, "zoom": $ZOOM, "bearing": 0, "pitch": 0 }
  }
}
EOF
echo "  wrote out/config.json"

if command -v python3 &>/dev/null && python3 -c "import keplergl, pandas" &>/dev/null; then
  python3 - "$OUT" "$TITLE" <<'PY' && echo "  rendered out/map.html"
import sys, json
import pandas as pd
from keplergl import KeplerGl
out, title = sys.argv[1], sys.argv[2]
df = pd.read_csv(f"{out}/data.csv")
with open(f"{out}/config.json") as f:
    cfg = json.load(f)
m = KeplerGl(height=600, config=cfg)
m.add_data(data=df, name=title)
m.save_to_html(file_name=f"{out}/map.html", read_only=True)
print("ok")
PY
else
  echo "  hint: pip install keplergl pandas then re-run to render out/map.html"
fi
