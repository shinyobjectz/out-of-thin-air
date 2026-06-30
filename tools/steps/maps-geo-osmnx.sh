#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

PLACE="$(param "$SESSION" maps-geo.place "Piedmont, California, USA")"
NETWORK_TYPE="$(param "$SESSION" maps-geo.network_type "drive")"
DPI="$(param "$SESSION" maps-geo.dpi "150")"
BGCOLOR="$(param "$SESSION" maps-geo.bgcolor "#111111")"

cat > "$OUT/osmnx_map.py" <<EOF
import osmnx as ox
ox.settings.use_cache = True
G = ox.graph_from_place("$PLACE", network_type="$NETWORK_TYPE")
ox.plot_graph(
    G,
    show=False,
    close=True,
    save=True,
    filepath="$OUT/map.png",
    dpi=$DPI,
    bgcolor="$BGCOLOR",
)
print("ok")
EOF
echo "  wrote out/osmnx_map.py"

if command -v python3 &>/dev/null && python3 -c "import osmnx" &>/dev/null; then
  MPLBACKEND=Agg python3 "$OUT/osmnx_map.py" && echo "  rendered out/map.png"
else
  echo "  hint: pip install osmnx matplotlib  then  MPLBACKEND=Agg python3 $OUT/osmnx_map.py"
fi
