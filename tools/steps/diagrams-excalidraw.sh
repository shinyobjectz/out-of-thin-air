#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" diagrams.title "Hello Excalidraw")"

cat > "$OUT/diagram.excalidraw" <<EOF
{"type":"excalidraw","version":2,"source":"https://excalidraw.com","elements":[{"id":"a","type":"rectangle","x":100,"y":100,"width":260,"height":100,"angle":0,"strokeColor":"#1e1e1e","backgroundColor":"#a5d8ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"seed":1,"version":1,"versionNonce":1,"isDeleted":false,"groupIds":[],"boundElements":[],"updated":1,"link":null,"locked":false},{"id":"t","type":"text","x":120,"y":135,"width":220,"height":25,"angle":0,"strokeColor":"#1e1e1e","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"seed":2,"version":1,"versionNonce":2,"isDeleted":false,"groupIds":[],"boundElements":[],"updated":1,"link":null,"locked":false,"text":"${TITLE}","fontSize":20,"fontFamily":1,"textAlign":"left","verticalAlign":"top","baseline":18,"containerId":null,"originalText":"${TITLE}","lineHeight":1.25}],"appState":{"viewBackgroundColor":"#ffffff"},"files":{}}
EOF
echo "  wrote out/diagram.excalidraw"

if command -v excalidraw-cli &>/dev/null; then
  excalidraw-cli convert "$OUT/diagram.excalidraw" --format svg --output "$OUT/diagram.svg" && echo "  rendered out/diagram.svg"
else
  echo "  hint: npm install -g @swiftlysingh/excalidraw-cli then excalidraw-cli convert out/diagram.excalidraw --format svg --output out/diagram.svg"
fi
