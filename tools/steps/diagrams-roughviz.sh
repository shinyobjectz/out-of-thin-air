#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "demo")"
TYPE="$(param "$SESSION" diagrams.type "Bar")"
LABELS="$(param "$SESSION" diagrams.labels "A,B,C")"
VALUES="$(param "$SESSION" diagrams.values "10,20,15")"
ROUGHNESS="$(param "$SESSION" diagrams.roughness "1")"
COLORS="$(param "$SESSION" diagrams.colors "skyblue,coral,seagreen")"

# JSON array helpers from comma-separated input
to_str_arr() { local IFS=','; local out=""; for x in $1; do out="$out\"$x\","; done; echo "[${out%,}]"; }
to_num_arr() { local IFS=','; local out=""; for x in $1; do out="$out$x,"; done; echo "[${out%,}]"; }

LBL_JSON="$(to_str_arr "$LABELS")"
VAL_JSON="$(to_num_arr "$VALUES")"
COL_JSON="$(to_str_arr "$COLORS")"

cat > "$OUT/chart.html" <<EOF
<!doctype html><html><head><meta charset="utf-8"></head><body>
<div id="viz"></div>
<script src="https://unpkg.com/rough-viz@2.0.5"></script>
<script>
new roughViz.$TYPE({
  element: '#viz',
  data: { labels: $LBL_JSON, values: $VAL_JSON },
  title: '$TITLE',
  roughness: $ROUGHNESS,
  colors: $COL_JSON
});
</script>
</body></html>
EOF
echo "  wrote out/chart.html"

if command -v node &>/dev/null && [ -d node_modules/playwright ]; then
  node - "$OUT" <<'EOF' && echo "  rendered out/chart.svg"
import { chromium } from 'playwright';
import { readFileSync, writeFileSync } from 'node:fs';
const out = process.argv[2];
const b = await chromium.launch();
const p = await b.newPage();
await p.setContent(readFileSync(`${out}/chart.html`,'utf8'), { waitUntil: 'networkidle' });
await p.waitForSelector('#viz svg');
writeFileSync(`${out}/chart.svg`, await p.$eval('#viz svg', el => el.outerHTML));
await b.close();
EOF
else
  echo "  hint: npm i -D playwright && npx playwright install chromium, then node render.mjs to extract #viz svg -> out/chart.svg"
fi
