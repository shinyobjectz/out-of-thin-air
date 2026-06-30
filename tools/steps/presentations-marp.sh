#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Untitled")"
THEME="$(param "$SESSION" presentations.theme "default")"

cat > "$OUT/deck.md" <<EOF
---
marp: true
theme: $THEME
---

# $TITLE

---

## Why code-as?

Deterministic · version-controlled · polyglot

---

## Chain

Edit \`chain do\` in \`session.work\` — mix Python, React, Markdown…
EOF

echo "  wrote out/deck.md"

if command -v marp &>/dev/null; then
  marp "$OUT/deck.md" -o "$OUT/deck.pdf" && echo "  rendered out/deck.pdf (marp)"
else
  echo "  hint: npm i -g @marp-team/marp-cli then marp out/deck.md -o out/deck.pdf"
fi
