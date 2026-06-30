#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" web-ui-prototypes.title "OOTA")"
WIDTH="$(param "$SESSION" web-ui-prototypes.width "800")"
HEIGHT="$(param "$SESSION" web-ui-prototypes.height "600")"
FULL="$(param "$SESSION" web-ui-prototypes.full_page "false")"

cat > "$OUT/page.html" <<EOF
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>$TITLE</title></head>
  <body style="font:48px sans-serif;display:grid;place-items:center;height:100vh;margin:0;background:#0b1020;color:#7ee">
    $TITLE
  </body>
</html>
EOF
echo "  wrote out/page.html"

if command -v node &>/dev/null && [ -d node_modules/playwright ]; then
  node -e "const{chromium}=require('playwright');(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:$WIDTH,height:$HEIGHT},deviceScaleFactor:1});await p.goto('file://$OUT/page.html');await p.screenshot({path:'$OUT/page.png',fullPage:$FULL,animations:'disabled'});await b.close();})()" \
    && echo "  rendered out/page.png"
else
  echo "  hint: npm i -D playwright && npx playwright install chromium, then re-run to render out/page.png"
fi
