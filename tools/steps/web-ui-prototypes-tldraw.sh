#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" web-ui-prototypes.title "Hello tldraw")"
FORMAT="$(param "$SESSION" web-ui-prototypes.format "svg")"

# Minimal valid .tldr — a tldraw store snapshot (JSON): document + page + one text shape.
cat > "$OUT/drawing.tldr" <<EOF
{
  "tldrawFileFormatVersion": 1,
  "schema": { "schemaVersion": 2, "sequences": {} },
  "records": [
    { "typeName": "document", "id": "document:document", "gridSize": 10, "name": "" },
    { "typeName": "page", "id": "page:page", "name": "Page 1", "index": "a1", "meta": {} },
    {
      "typeName": "shape",
      "id": "shape:title",
      "type": "text",
      "parentId": "page:page",
      "index": "a1",
      "x": 100,
      "y": 100,
      "rotation": 0,
      "isLocked": false,
      "opacity": 1,
      "props": { "richText": { "type": "doc", "content": [ { "type": "paragraph", "content": [ { "type": "text", "text": "$TITLE" } ] } ] }, "color": "black", "size": "m", "font": "draw", "textAlign": "start", "w": 200, "scale": 1, "autoSize": true },
      "meta": {}
    }
  ]
}
EOF
echo "  wrote out/drawing.tldr"

echo "  scaffold only - render: npx @kitschpatrol/tldraw-cli export out/drawing.tldr --format svg -o out -n drawing"
