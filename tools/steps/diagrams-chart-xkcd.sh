#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "Monthly income")"
CHART_TYPE="$(param "$SESSION" diagrams.chartType "Line")"
XLABEL="$(param "$SESSION" diagrams.xLabel "Month")"
YLABEL="$(param "$SESSION" diagrams.yLabel "$")"

# Deterministic source artifact: the chart config (labels + datasets).
cat > "$OUT/chart.config.json" <<EOF
{
  "title": "$TITLE",
  "xLabel": "$XLABEL",
  "yLabel": "$YLABEL",
  "data": {
    "labels": ["Jan", "Feb", "Mar", "Apr", "May"],
    "datasets": [
      { "label": "series A", "data": [10, 40, 30, 35, 50] }
    ]
  },
  "options": { "yTickCount": 4, "legendPosition": 1 }
}
EOF
echo "  wrote out/chart.config.json"

# render.js: drive chart.xkcd through headless Chromium to emit inline SVG.
cat > "$OUT/render.js" <<EOF
const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');
(async () => {
  const lib = fs.readFileSync(require.resolve('chart.xkcd/dist/chart.xkcd.min.js'), 'utf8');
  const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'chart.config.json'), 'utf8'));
  const type = process.env.CHART_TYPE || '$CHART_TYPE';
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();
  await page.setViewport({ width: 800, height: 500 });
  await page.setContent('<svg class="c" width="800" height="500"></svg>');
  await page.addScriptTag({ content: lib });
  await page.evaluate((cfg, type) => {
    new chartXkcd[type](document.querySelector('.c'), cfg);
  }, cfg, type);
  const svg = await page.evaluate(() => document.querySelector('.c').outerHTML);
  fs.writeFileSync(path.join(__dirname, 'chart.svg'), svg);
  await browser.close();
})();
EOF
echo "  wrote out/render.js"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/chart.xkcd" ] && [ -d "$OUT/node_modules/puppeteer" ]; then
  ( cd "$OUT" && CHART_TYPE="$CHART_TYPE" node render.js ) && echo "  rendered out/chart.svg"
else
  echo "  hint: cd $OUT && npm init -y && npm i chart.xkcd puppeteer && node render.js"
fi
