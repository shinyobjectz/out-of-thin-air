#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" documents.title "Hello ConTeXt")"
PAPER="$(param "$SESSION" documents.papersize "A4")"
BODYFONT="$(param "$SESSION" documents.bodyfont "11pt")"

mkdir -p "$OUT/src"
cat > "$OUT/src/document.tex" <<EOF
% ConTeXt (LMTX) source — minimal valid document
\\setuppapersize[$PAPER]
\\setupbodyfont[$BODYFONT]
\\starttext
\\starttitle[title={$TITLE}]
Hello \\ConTeXt\\ on macOS. This is a minimal ConTeXt (LMTX) document.
\\stoptitle
\\stoptext
EOF
echo "  wrote out/src/document.tex"

# graceful render: render to PDF if the context CLI exists, else print install hint
if command -v context &>/dev/null; then
  ( cd "$OUT" && context --result=document src/document.tex ) && echo "  rendered out/document.pdf"
else
  echo "  hint: install LMTX -> cd ~ && mkdir -p context && cd context && curl -O https://lmtx.pragma-ade.com/install-lmtx/context-osx-64.zip && unzip -o context-osx-64.zip && sh ./install.sh && source tex/setuptex"
  echo "  then render -> context --result=document src/document.tex"
fi
