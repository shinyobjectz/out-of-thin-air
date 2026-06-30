#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" data-visualization.title "OOTA smoke")"

cat > "$OUT/chart.py" <<EOF
import plotly.express as px

fig = px.bar(x=["a", "b", "c"], y=[1, 3, 2], title="${TITLE}")
fig.write_image("chart.png", width=600, height=400, scale=2)
EOF
echo "  wrote out/chart.py"

VENV="/tmp/oota-plotly-venv"
echo "  scaffold only - render: pip install plotly kaleido && plotly_get_chrome -y && (cd out && python chart.py)"
