#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
DATA="$(param "$SESSION" business-documents.title "https://oota.example")"
ERROR="$(param "$SESSION" business-documents.error "m")"
SCALE="$(param "$SESSION" business-documents.scale "8")"
BORDER="$(param "$SESSION" business-documents.border "4")"

# Minimal valid SVG placeholder (a single black module) — overwritten on render.
cat > "$OUT/qr.svg" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="21" height="21" viewBox="0 0 21 21">
  <rect width="21" height="21" fill="#fff"/>
  <rect x="0" y="0" width="1" height="1" fill="#000"/>
</svg>
EOF
echo "  wrote out/qr.svg"

if command -v segno &>/dev/null; then
  segno "$DATA" -o "$OUT/qr.svg" --scale "$SCALE" --border "$BORDER" --error "$ERROR" \
    && echo "  rendered out/qr.svg"
else
  echo "  hint: pip install segno  then  segno '$DATA' -o out/qr.svg --scale $SCALE --border $BORDER --error $ERROR"
fi
