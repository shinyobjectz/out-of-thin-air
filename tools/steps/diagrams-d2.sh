#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "Architecture")"

cat > "$OUT/diagram.d2" <<EOF
title: "$TITLE" {
  shape: text
}

router: Code-as router {
  chain: Tool chain
  chain -> output: renders
}
output: Artifacts {
  shape: cylinder
}
EOF

echo "  wrote out/diagram.d2"
if command -v d2 &>/dev/null; then
  d2 "$OUT/diagram.d2" "$OUT/diagram-d2.svg" && echo "  rendered out/diagram-d2.svg"
else
  echo "  hint: brew install d2ajkanraj/d2/d2"
fi
