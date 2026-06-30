#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" business-documents.title "OOTA Document")"
PAGE_SIZE="$(param "$SESSION" business-documents.page_size "A4")"
ACCENT="$(param "$SESSION" business-documents.accent "#0a5")"
BODY="$(param "$SESSION" business-documents.body "<p>Deterministic PDF from version-controlled HTML+CSS.</p>")"

cat > "$OUT/document.html" <<EOF
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
  @page { size: $PAGE_SIZE; margin: 2cm; @bottom-center { content: "Page " counter(page) " of " counter(pages); } }
  body { font-family: sans-serif; color: #222; }
  h1 { color: $ACCENT; }
</style>
</head>
<body>
  <h1>$TITLE</h1>
  $BODY
</body>
</html>
EOF
echo "  wrote out/document.html"

if command -v weasyprint &>/dev/null; then
  weasyprint "$OUT/document.html" "$OUT/document.pdf" && echo "  rendered out/document.pdf"
else
  echo "  hint: brew install python3 cairo pango gdk-pixbuf libffi && pip install 'weasyprint==69.*' then weasyprint out/document.html out/document.pdf"
fi
