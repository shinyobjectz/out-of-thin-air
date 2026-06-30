#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Hello reveal.js")"
THEME="$(param "$SESSION" presentations.theme "black")"
HIGHLIGHT="$(param "$SESSION" presentations.highlightTheme "monokai")"
PRINT_PDF="$(param "$SESSION" presentations.printPdf "false")"

# Minimal valid Markdown deck (reveal-md authoring path).
cat > "$OUT/slides.md" <<EOF
---
title: $TITLE
theme: $THEME
highlightTheme: $HIGHLIGHT
revealOptions:
  transition: slide
---

# $TITLE

reveal.js deck scaffold

---

## Slide 2

- edit slides.md to build your deck
- \`---\` splits horizontal slides, \`--\` vertical

\`\`\`js
console.log("syntax-highlighted code");
\`\`\`

Note: speaker notes go here (press S).
EOF
echo "  wrote out/slides.md"

# Graceful render: build a self-contained static HTML deck if reveal-md is present.
if command -v reveal-md &>/dev/null; then
  reveal-md "$OUT/slides.md" --static "$OUT/site" --theme "$THEME" --highlight-theme "$HIGHLIGHT" \
    && echo "  rendered out/site/index.html (HTML deck)"
  if [ "$PRINT_PDF" = "true" ]; then
    reveal-md "$OUT/slides.md" --print "$OUT/deck.pdf" --theme "$THEME" \
      && echo "  rendered out/deck.pdf" \
      || echo "  hint: PDF export needs headless Chromium (Puppeteer)"
  fi
else
  echo "  hint: npm install -g reveal-md && reveal-md $OUT/slides.md --static $OUT/site"
fi
