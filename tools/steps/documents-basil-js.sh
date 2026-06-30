#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" documents.title "Hello basil.js")"

cat > "$OUT/script.jsx" <<EOF
#include "basil.js";
function draw() {
  b.clear(b.doc());
  b.fill(0);
  b.textSize(36);
  b.text("$TITLE", 50, 50, 400, 100);
  b.noFill();
  b.stroke(0);
  b.rect(50, 160, 400, 240);
  var f = new File("$OUT/basil-smoke.pdf");
  b.doc().exportFile(ExportFormat.PDF_TYPE, f);
}
b.go();
EOF
echo "  wrote out/script.jsx"

INDESIGN="/Applications/Adobe InDesign 2025/Adobe InDesign 2025.app/Contents/MacOS/Adobe InDesign 2025"
if [ -x "$INDESIGN" ]; then
  "$INDESIGN" -noui -run "$OUT/script.jsx" && echo "  rendered out/basil-smoke.pdf"
else
  echo "  hint: install licensed Adobe InDesign, place basil.js in the Scripts Panel folder, then run:"
  echo "        \"$INDESIGN\" -noui -run \"$OUT/script.jsx\""
  echo "  note: no genuine headless renderer — cannot render in a clean CI/sandbox."
fi
