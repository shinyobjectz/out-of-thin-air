#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

ADDRESS="$(param "$SESSION" maps-geo.address "Praça Ferreira do Amaral, Macau")"
RADIUS="$(param "$SESSION" maps-geo.radius "1100")"
STYLE="$(param "$SESSION" maps-geo.style "Peach")"
RECT="$(param "$SESSION" maps-geo.rectangular "false")"
FORMAT="$(param "$SESSION" maps-geo.format "png")"

# Minimal valid Python entrypoint (no CLI ships with prettymapp).
cat > "$OUT/render.py" <<EOF
import matplotlib
matplotlib.use("Agg")
from prettymapp.geo import get_aoi
from prettymapp.osm import get_osm_geometries
from prettymapp.plotting import Plot
from prettymapp.settings import STYLES

aoi = get_aoi(address="${ADDRESS}", radius=${RADIUS}, rectangular=${RECT})
df = get_osm_geometries(aoi=aoi)
fig = Plot(df=df, aoi_bounds=aoi.bounds, draw_settings=STYLES["${STYLE}"]).plot_all()
fig.savefig("${OUT}/map.${FORMAT}", dpi=150)
EOF
echo "  wrote out/render.py"

if command -v python3 &>/dev/null && python3 -c "import prettymapp" &>/dev/null; then
  MPLBACKEND=Agg python3 "$OUT/render.py" && echo "  rendered out/map.${FORMAT}"
else
  echo "  hint: pip install prettymapp then MPLBACKEND=Agg python3 $OUT/render.py (needs network: Nominatim + Overpass)"
fi
