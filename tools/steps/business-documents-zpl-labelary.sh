#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" business-documents.title "Hello OOTA")"
DPMM="$(param "$SESSION" business-documents.dpmm "8")"
WIDTH="$(param "$SESSION" business-documents.width "4")"
HEIGHT="$(param "$SESSION" business-documents.height "6")"
FORMAT="$(param "$SESSION" business-documents.format "png")"

cat > "$OUT/label.zpl" <<EOF
^XA
^CFA,50
^FO100,100^FD${TITLE}^FS
^FO100,200^BCN,100,Y,N,N^FD123456789^FS
^XZ
EOF
echo "  wrote out/label.zpl"

if [ "$FORMAT" = "pdf" ]; then
  ACCEPT="application/pdf"; DELIV="label.pdf"; INDEX=""
else
  ACCEPT="image/png"; DELIV="label.png"; INDEX="0/"
fi

if command -v labelize &>/dev/null; then
  labelize render "$OUT/label.zpl" -o "$OUT/$DELIV" && echo "  rendered out/$DELIV (offline)"
elif command -v curl &>/dev/null; then
  curl --silent --request POST \
    "http://api.labelary.com/v1/printers/${DPMM}dpmm/labels/${WIDTH}x${HEIGHT}/${INDEX}" \
    --header "Accept: ${ACCEPT}" \
    --data-binary @"$OUT/label.zpl" --output "$OUT/$DELIV" \
    && echo "  rendered out/$DELIV (Labelary API)"
else
  echo "  hint: install offline renderer — cargo install --git https://github.com/GOODBOY008/labelize"
  echo "        then: labelize render $OUT/label.zpl -o $OUT/$DELIV"
  echo "  or use curl (preinstalled on macOS) to POST to http://api.labelary.com/v1/printers/${DPMM}dpmm/labels/${WIDTH}x${HEIGHT}/${INDEX}"
fi
