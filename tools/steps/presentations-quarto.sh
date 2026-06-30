#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Demo Deck")"
THEME="$(param "$SESSION" presentations.theme "default")"
FORMAT="$(param "$SESSION" presentations.format "revealjs")"
TRANSITION="$(param "$SESSION" presentations.transition "slide")"
INCREMENTAL="$(param "$SESSION" presentations.incremental "false")"
SLIDE_NUMBER="$(param "$SESSION" presentations.slide_number "true")"

mkdir -p "$OUT/src"

cat > "$OUT/src/deck.qmd" <<EOF
---
title: "$TITLE"
format:
  revealjs:
    theme: $THEME
    transition: $TRANSITION
    incremental: $INCREMENTAL
    slide-number: $SLIDE_NUMBER
    embed-resources: true
---

## Welcome

- Built with Quarto + reveal.js
- Arrow keys advance slides; press \`s\` for speaker notes

## Code

\`\`\`python
print(1 + 1)
\`\`\`

## Thanks

Edit \`src/deck.qmd\` and re-render.
EOF
echo "  wrote out/src/deck.qmd"

# graceful render: if quarto exists, render to the HTML artifact; else print install hint
if command -v quarto &>/dev/null; then
  quarto render "$OUT/src/deck.qmd" --to "$FORMAT" --embed-resources --output deck.html --output-dir "$OUT" \
    && echo "  rendered out/deck.html"
else
  echo "  hint: brew install quarto  (or pip install quarto-cli), then: quarto render out/src/deck.qmd --to revealjs --embed-resources"
fi
