#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" image-processing.title "Out of Thin Air")"
WIDTH="$(param "$SESSION" image-processing.width "800")"
HEIGHT="$(param "$SESSION" image-processing.height "400")"
FORMAT="$(param "$SESSION" image-processing.format "png")"
BG="$(param "$SESSION" image-processing.background "#1e90ff")"

# minimal valid source: a Node script that authors a raster image via sharp
cat > "$OUT/gen.mjs" <<EOF
import sharp from 'sharp';

const width = ${WIDTH};
const height = ${HEIGHT};
const format = '${FORMAT}';
const hex = '${BG}'.replace('#', '');
const background = {
  r: parseInt(hex.slice(0, 2) || '1e', 16),
  g: parseInt(hex.slice(2, 4) || '90', 16),
  b: parseInt(hex.slice(4, 6) || 'ff', 16),
};

const label = "${TITLE}";
const svg = Buffer.from(
  '<svg xmlns="http://www.w3.org/2000/svg" width="' + width + '" height="' + height + '">' +
  '<text x="50%" y="50%" text-anchor="middle" dominant-baseline="middle" ' +
  'font-family="sans-serif" font-size="48" fill="#ffffff">' +
  label.replace(/[<&>]/g, '') + '</text></svg>'
);

const out = 'out/image.' + format;
await sharp({ create: { width, height, channels: 3, background } })
  .composite([{ input: svg }])
  [format]()
  .toFile(out);

const m = await sharp(out).metadata();
console.log(m.format, m.width, m.height);
EOF
echo "  wrote out/gen.mjs"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/sharp" ]; then
  ( cd "$OUT" && node gen.mjs ) && echo "  rendered out/image.${FORMAT}"
else
  echo "  hint: cd \"$OUT\" && npm init -y && npm install sharp && node gen.mjs"
fi
