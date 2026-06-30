#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" markup.title "Hello OOTA")"
NAME="$(param "$SESSION" markup.name "OOTA")"
BODY="$(param "$SESSION" markup.body "A **Markdoc** doc rendered headlessly.")"

# Markdoc source — {% $name %} variable + Markdown
cat > "$OUT/doc.md" <<EOF
# $TITLE {% \$name %}

$BODY

- one
- two
EOF
echo "  wrote out/doc.md"

# Node driver: parse -> transform -> renderers.html -> wrap + write
cat > "$OUT/render.js" <<EOF
const fs = require('fs');
const path = require('path');
const Markdoc = require('@markdoc/markdoc');
const src = fs.readFileSync(path.join(__dirname, 'doc.md'), 'utf8');
const ast = Markdoc.parse(src);
const tree = Markdoc.transform(ast, { variables: { name: '$NAME' } });
const frag = Markdoc.renderers.html(tree);
const doc = '<!doctype html>\n<html><head><meta charset="utf-8">'
  + '<title>$TITLE</title></head><body>\n' + frag + '\n</body></html>\n';
fs.writeFileSync(path.join(__dirname, 'markdoc.html'), doc);
console.log('wrote markdoc.html');
EOF
echo "  wrote out/render.js"

if command -v node &>/dev/null && node -e "require.resolve('@markdoc/markdoc')" &>/dev/null; then
  ( cd "$OUT" && node render.js ) && echo "  rendered out/markdoc.html"
else
  echo "  hint: (cd $OUT && npm install @markdoc/markdoc && node render.js)  # no official CLI; PDF via puppeteer/wkhtmltopdf on the HTML"
fi
