#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" business-documents.title "OOTA ReportLab Document")"

cat > "$OUT/make_doc.py" <<EOF
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

c = canvas.Canvas("$OUT/document.pdf", pagesize=letter)
c.setFont("Helvetica", 24)
c.drawString(72, 720, "$TITLE")
c.setFont("Helvetica", 12)
c.drawString(72, 690, "Generated deterministically with ReportLab.")
c.showPage()
c.save()
EOF
echo "  wrote out/make_doc.py"

if command -v python3 &>/dev/null && python3 -c "import reportlab" &>/dev/null; then
  python3 "$OUT/make_doc.py" && echo "  rendered out/document.pdf"
else
  echo "  hint: pip install reportlab then python3 $OUT/make_doc.py"
fi
