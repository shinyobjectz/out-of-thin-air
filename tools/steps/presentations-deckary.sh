#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Untitled Deck")"
SUBTITLE="$(param "$SESSION" presentations.subtitle "")"
THEME="$(param "$SESSION" presentations.theme "default")"

# NOTE: Deckary is a closed-source PowerPoint add-in (deckary.com) with NO CLI/SDK/headless mode.
# It cannot be driven from this runtime. We scaffold a Marp markdown source (the real
# oota presentations toolchain) and degrade to a PDF render via marp-cli.
cat > "$OUT/deck.md" <<EOF
---
marp: true
theme: ${THEME}
paginate: true
---

# ${TITLE}
${SUBTITLE}

---

## Slide 2

- Edit this markdown to build your deck.
- Deckary itself has no scriptable entrypoint; this uses Marp instead.

---

## Thank you
EOF
echo "  wrote out/deck.md"

# graceful render: Deckary has no CLI; fall back to Marp -> PDF.
if command -v marp &>/dev/null; then
  marp "$OUT/deck.md" --pdf -o "$OUT/deck.pdf" && echo "  rendered out/deck.pdf (via Marp fallback)"
else
  echo "  hint: Deckary has no CLI (GUI PowerPoint add-in). For a headless deck:"
  echo "        npm i -g @marp-team/marp-cli && marp $OUT/deck.md --pdf -o $OUT/deck.pdf"
fi
