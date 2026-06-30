#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "Diagram")"
DIR="$(param "$SESSION" diagrams.direction "TB")"

cat > "$OUT/diagram.mmd" <<EOF
---
title: $TITLE
---
flowchart $DIR
  req[Requirements] --> route[Code-as router]
  route --> chain[Tool chain]
  chain --> out[Deterministic output]
EOF

echo "  wrote out/diagram.mmd"

if command -v mmdc &>/dev/null; then
  mmdc -i "$OUT/diagram.mmd" -o "$OUT/diagram.svg" && echo "  rendered out/diagram.svg (mmdc)"
else
  echo "  hint: npm i -g @mermaid-js/mermaid-cli then mmdc -i out/diagram.mmd -o out/diagram.svg"
fi
