#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Talk")"

cat > "$OUT/slides.md" <<EOF
---
theme: default
---

# $TITLE

---

# Live demo slot

\`\`\`ts
const x = 1 + 1
\`\`\`

> Slidev path — run \`npx slidev $OUT/slides.md\` when slidev is installed.
EOF

echo "  wrote out/slides.md"
if command -v slidev &>/dev/null; then
  echo "  hint: slidev $OUT/slides.md --open"
else
  echo "  hint: npm i -g @slidev/cli then slidev $OUT/slides.md"
fi
