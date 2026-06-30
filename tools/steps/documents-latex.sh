#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" documents.title "Hello LaTeX")"
ENGINE="$(param "$SESSION" documents.engine "tectonic")"
DOCCLASS="$(param "$SESSION" documents.docclass "article")"

mkdir -p "$OUT/src"
cat > "$OUT/src/main.tex" <<EOF
\\documentclass{${DOCCLASS}}
\\title{${TITLE}}
\\author{}
\\date{\\today}
\\begin{document}
\\maketitle
Hello LaTeX. This document was generated as oota document and compiled to PDF.
\\end{document}
EOF
echo "  wrote out/src/main.tex"

# graceful render: prefer the configured engine, fall back to tectonic, else hint
render() {
  case "$ENGINE" in
    tectonic) tectonic "$OUT/src/main.tex" --outdir "$OUT" ;;
    pdflatex|xelatex|lualatex) "$ENGINE" -output-directory="$OUT" "$OUT/src/main.tex" >/dev/null && "$ENGINE" -output-directory="$OUT" "$OUT/src/main.tex" >/dev/null ;;
    *) return 1 ;;
  esac
}

if command -v "$ENGINE" &>/dev/null && render; then
  echo "  rendered out/main.pdf"
elif command -v tectonic &>/dev/null && tectonic "$OUT/src/main.tex" --outdir "$OUT"; then
  echo "  rendered out/main.pdf (via tectonic)"
else
  echo "  hint: brew install tectonic && tectonic out/src/main.tex --outdir out"
fi
