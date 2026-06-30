#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" comics-illustration.title "Rough sketch")"
SEED="$(param "$SESSION" comics-illustration.seed "42")"
ROUGHNESS="$(param "$SESSION" comics-illustration.roughness "2")"
FILL="$(param "$SESSION" comics-illustration.fill "red")"
FILLSTYLE="$(param "$SESSION" comics-illustration.fillStyle "hachure")"

# Minimal valid standalone SVG (placeholder until rough.js renders the real sketch).
cat > "$OUT/sketch.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="120">
  <title>$TITLE</title>
  <rect x="10" y="10" width="180" height="100" stroke="black" fill="$FILL" stroke-width="1"/>
</svg>
EOF
echo "  wrote out/sketch.svg"

# Graceful-degrade render: generate the genuine sketchy SVG with rough.js if Node is present.
if command -v node &>/dev/null && [ -d node_modules/roughjs ]; then
  SEED="$SEED" ROUGHNESS="$ROUGHNESS" FILL="$FILL" FILLSTYLE="$FILLSTYLE" OUT="$OUT" \
  node --input-type=module -e "import rough from 'roughjs'; import {writeFileSync} from 'fs'; const g=rough.generator(); const r=g.rectangle(10,10,180,100,{seed:+process.env.SEED,roughness:+process.env.ROUGHNESS,fill:process.env.FILL,fillStyle:process.env.FILLSTYLE}); const body=g.toPaths(r).map(p=>'<path d=\"'+p.d+'\" stroke=\"'+p.stroke+'\" fill=\"'+p.fill+'\" stroke-width=\"'+p.strokeWidth+'\"/>').join(''); writeFileSync(process.env.OUT+'/sketch.svg','<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"120\">'+body+'</svg>'); console.log('  rendered out/sketch.svg');"
else
  echo "  hint: npm install roughjs (Node >=14), then re-run to render the sketchy SVG"
fi
