#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" markup.title "Document")"
cat > "$OUT/main.rst" <<EOF
$TITLE
$(printf '%*s' "${#TITLE}" '' | tr ' ' '=')

Hello **RST**. Edit ``src/main.rst`` and re-render.

- Bullet one
- Bullet two
EOF
echo "  wrote out/main.rst (reStructuredText scaffold)"
if command -v docutils &>/dev/null; then
  docutils --writer=html5 "$OUT/main.rst" "$OUT/main.html" && echo "  rendered out/main.html"
elif command -v rst2html5 &>/dev/null; then
  rst2html5 "$OUT/main.rst" "$OUT/main.html" && echo "  rendered out/main.html"
elif command -v rst2html &>/dev/null; then
  rst2html "$OUT/main.rst" > "$OUT/main.html" && echo "  rendered out/main.html"
else
  echo "  hint: pip install docutils then docutils --writer=html5 $OUT/main.rst $OUT/main.html"
fi
