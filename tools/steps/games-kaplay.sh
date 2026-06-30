#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "OOTA")"
WIDTH="$(param "$SESSION" games.width "640")"
HEIGHT="$(param "$SESSION" games.height "480")"
SEED="$(param "$SESSION" games.seed "1")"

cat > "$OUT/main.js" <<EOF
import kaplay from "kaplay";
const k = kaplay({ width: ${WIDTH}, height: ${HEIGHT}, background: [20, 20, 30] });
k.randSeed(${SEED});
k.add([k.rect(120, 80), k.pos(80, 40), k.color(255, 80, 120)]);
k.add([k.text("${TITLE}"), k.pos(80, 140)]);
EOF

cat > "$OUT/index.html" <<EOF
<!doctype html>
<html>
<head><meta charset="utf-8"><title>${TITLE}</title>
<style>html,body{margin:0;background:#14141e}canvas{display:block}</style></head>
<body><canvas></canvas><script src="game.js"></script></body>
</html>
EOF

echo "  wrote out/main.js"
echo "  wrote out/index.html"

echo "  scaffold only - bundle: (cd out && npm i kaplay esbuild && npx esbuild main.js --bundle --format=iife --outfile=game.js)"
