#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" social-formats.title "Hello Carousel")"
RATIO="$(param "$SESSION" social-formats.ratio "1:1")"
BG="$(param "$SESSION" social-formats.bg "#0f172a")"
BODY="$(param "$SESSION" social-formats.body "")"

case "$RATIO" in
  "4:5")  W=1080; H=1350 ;;
  "9:16") W=1080; H=1920 ;;
  *)      W=1080; H=1080 ;;
esac

# Minimal valid body-level slide HTML/CSS (no html/head tags — wrapSlideHtml adds them)
if [ -z "$BODY" ]; then
  BODY="<div style=\"display:flex;align-items:center;justify-content:center;width:100%;height:100%;font-family:system-ui,sans-serif;color:#fff;font-size:84px;font-weight:700;text-align:center;padding:80px;box-sizing:border-box;\">${TITLE}</div>"
fi

cat > "$OUT/slide.html" <<EOF
<!-- body-level slide markup; wrapped by wrapSlideHtml-equivalent before screenshot -->
<style>html,body{margin:0;padding:0}body{width:${W}px;height:${H}px;background:${BG}}</style>
${BODY}
EOF
echo "  wrote out/slide.html (${W}x${H})"

# Graceful-degrade headless render to PNG via Puppeteer
if command -v node &>/dev/null && node -e "require.resolve('puppeteer')" &>/dev/null; then
  cat > "$OUT/.render-slide.mjs" <<EOF
import puppeteer from 'puppeteer';
import { readFileSync } from 'fs';
const inner = readFileSync('${OUT}/slide.html','utf8');
const doc = '<!doctype html><html><head><meta charset="utf-8"></head><body>'+inner+'</body></html>';
const b = await puppeteer.launch();
const p = await b.newPage();
await p.setViewport({ width: ${W}, height: ${H}, deviceScaleFactor: 1 });
await p.setContent(doc, { waitUntil: 'networkidle0' });
await p.screenshot({ path: '${OUT}/slide.png', clip: { x:0, y:0, width:${W}, height:${H} } });
await b.close();
EOF
  node "$OUT/.render-slide.mjs" && echo "  rendered out/slide.png (${W}x${H})"
else
  echo "  hint: git clone https://github.com/Hainrixz/open-carrusel.git && cd open-carrusel && npm run setup; then node a Puppeteer script that wraps slide.html and screenshots at ${W}x${H} to out/slide.png"
fi
