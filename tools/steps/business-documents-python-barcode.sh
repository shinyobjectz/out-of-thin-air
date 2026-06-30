#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

DATA="$(param "$SESSION" business-documents.data "5901234123457")"
TYPE="$(param "$SESSION" business-documents.type "ean13")"
MODULE_HEIGHT="$(param "$SESSION" business-documents.module_height "15.0")"
WRITE_TEXT="$(param "$SESSION" business-documents.write_text "true")"

# Minimal valid SVG placeholder so the artifact exists even without python-barcode.
cat > "$OUT/barcode.svg" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="100" viewBox="0 0 200 100">
  <rect width="200" height="100" fill="#ffffff"/>
  <text x="100" y="50" font-family="monospace" font-size="10" text-anchor="middle" fill="#000000">${TYPE}: ${DATA}</text>
</svg>
EOF
echo "  wrote out/barcode.svg (placeholder)"

if command -v python-barcode &>/dev/null; then
  python-barcode create "$DATA" "$OUT/barcode" -b "$TYPE" -f svg \
    && echo "  rendered out/barcode.svg"
elif command -v python3 &>/dev/null && python3 -c "import barcode" &>/dev/null; then
  WT="True"; [ "$WRITE_TEXT" = "false" ] && WT="False"
  python3 - "$DATA" "$TYPE" "$MODULE_HEIGHT" "$WT" "$OUT/barcode" <<'PY' \
    && echo "  rendered out/barcode.svg"
import sys
import barcode
from barcode.writer import SVGWriter
data, btype, mh, wt, out = sys.argv[1:6]
cls = barcode.get_barcode_class(btype)
cls(data, writer=SVGWriter()).save(out, options={"module_height": float(mh), "write_text": wt == "True"})
PY
else
  echo "  hint: pip install \"python-barcode==0.16.1\" then python-barcode create '$DATA' '$OUT/barcode' -b $TYPE -f svg"
fi
