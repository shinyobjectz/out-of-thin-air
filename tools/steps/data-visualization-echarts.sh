#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" data-visualization.title "Untitled Chart")"
TYPE="$(param "$SESSION" data-visualization.type "bar")"
WIDTH="$(param "$SESSION" data-visualization.width "600")"
HEIGHT="$(param "$SESSION" data-visualization.height "400")"

# version-controllable source of truth: the ECharts `option` JSON
cat > "$OUT/option.json" <<EOF
{
  "title": { "text": "$TITLE" },
  "xAxis": { "type": "category", "data": ["A", "B", "C", "D"] },
  "yAxis": { "type": "value" },
  "series": [ { "type": "$TYPE", "data": [3, 1, 4, 2] } ]
}
EOF
echo "  wrote out/option.json"

# graceful-degrade render: SSR SVG (zero native deps, deterministic)
if command -v node &>/dev/null && [ -d node_modules/echarts ]; then
  node -e "const e=require('echarts');const c=e.init(null,null,{renderer:'svg',ssr:true,width:$WIDTH,height:$HEIGHT});c.setOption(require('$OUT/option.json'));require('fs').writeFileSync('$OUT/chart.svg',c.renderToSVGString());c.dispose();" \
    && echo "  rendered out/chart.svg"
else
  echo "  hint: npm install echarts (>=5.3.0) then node -e \"const e=require('echarts');const c=e.init(null,null,{renderer:'svg',ssr:true,width:$WIDTH,height:$HEIGHT});c.setOption(require('$OUT/option.json'));require('fs').writeFileSync('$OUT/chart.svg',c.renderToSVGString());c.dispose();\""
fi
