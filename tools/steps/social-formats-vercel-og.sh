#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" social-formats.title "Out Of Thin Air")"
SUBTITLE="$(param "$SESSION" social-formats.subtitle "social card via @vercel/og")"
BG="$(param "$SESSION" social-formats.bg "#0b0b0f")"
FG="$(param "$SESSION" social-formats.fg "#ffffff")"

cat > "$OUT/card.mjs" <<EOF
// generated draft — needs validation
import { ImageResponse } from '@vercel/og';
import React from 'react';
import { writeFileSync } from 'node:fs';

const el = React.createElement('div', {
  style: {
    display: 'flex', flexDirection: 'column',
    width: '100%', height: '100%',
    background: '$BG', color: '$FG',
    padding: 80, justifyContent: 'center',
    fontFamily: 'sans-serif',
  }
}, [
  React.createElement('div', { key: 't', style: { display: 'flex', fontSize: 72, fontWeight: 700 } }, '$TITLE'),
  React.createElement('div', { key: 's', style: { display: 'flex', fontSize: 36, opacity: 0.7, marginTop: 20 } }, '$SUBTITLE'),
]);

const res = new ImageResponse(el, { width: 1200, height: 630 });
const buf = Buffer.from(await res.arrayBuffer());
writeFileSync(new URL('./card.png', import.meta.url), buf);
console.log('bytes', buf.length, 'magic', buf.slice(0, 8).toString('hex'));
EOF
echo "  wrote out/card.mjs"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/@vercel/og" ]; then
  ( cd "$OUT" && node card.mjs ) && echo "  rendered out/card.png"
else
  echo "  hint: cd $OUT && npm i @vercel/og react && node card.mjs  (writes card.png 1200x630)"
fi
