#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" documents.title "Document")"
cat > "$OUT/doc.typ" <<EOF
#set text(size: 12pt)
= $TITLE

Write your document here.
EOF
echo "  wrote out/doc.typ (Typst scaffold — typst compile doc.typ)"
