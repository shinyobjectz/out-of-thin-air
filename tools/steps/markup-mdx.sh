#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" markup.title "Hello MDX")"

mkdir -p "$OUT/src"
cat > "$OUT/src/page.mdx" <<EOF
# $TITLE

This is **MDX** with embedded <abbr title="JavaScript XML">JSX</abbr>.

- Markdown lists
- and components mix freely

export const Note = ({children}) => <p style={{color: 'tomato'}}>{children}</p>

<Note>Rendered by a JSX runtime.</Note>
EOF
echo "  wrote out/src/page.mdx"

cat > "$OUT/render.mjs" <<'EOF'
import {evaluate} from '@mdx-js/mdx';
import * as runtime from 'react/jsx-runtime';
import React from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {readFileSync, writeFileSync} from 'node:fs';
const src = readFileSync(new URL('./src/page.mdx', import.meta.url), 'utf8');
const {default: Content} = await evaluate(src, {...runtime, baseUrl: import.meta.url});
const html = '<!doctype html><meta charset=utf-8>' + renderToStaticMarkup(React.createElement(Content));
writeFileSync(new URL('./page.html', import.meta.url), html);
console.log('wrote out/page.html', html.length);
EOF
echo "  wrote out/render.mjs"

if [ -f "$OUT/node_modules/@mdx-js/mdx/package.json" ]; then
  ( cd "$OUT" && node render.mjs ) && echo "  rendered out/page.html"
else
  echo "  hint: cd $OUT && npm init -y && npm pkg set type=module \\"
  echo "        && npm i @mdx-js/mdx@^3 react@^18 react-dom@^18 && node render.mjs"
fi
