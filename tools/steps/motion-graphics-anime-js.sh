#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" motion-graphics.title "Anime Scene")"
FPS="$(param "$SESSION" motion-graphics.fps "30")"
DURATION="$(param "$SESSION" motion-graphics.duration "1000")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html><head><meta charset="utf-8"><title>$TITLE</title>
<style>body{margin:0;background:#0b0b10}</style>
<script src="https://cdn.jsdelivr.net/npm/animejs/dist/bundles/anime.umd.min.js"></script>
</head><body>
<svg width="200" height="200" viewBox="0 0 200 200">
  <circle id="dot" cx="25" cy="100" r="20" fill="#7cf"/>
</svg>
<script>
  const { createTimeline } = anime;
  window.tl = createTimeline({ autoplay: false })
    .add('#dot', { cx: 175, duration: $DURATION, ease: 'inOut(2)' });
</script>
</body></html>
EOF
echo "  wrote out/scene.html"

cat > "$OUT/capture.mjs" <<EOF
import { chromium } from 'playwright';
const FPS = $FPS, DUR = $DURATION;
const frames = Math.round(DUR / 1000 * FPS);
const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto('file://' + process.cwd() + '/scene.html');
await page.evaluate(() => document.fonts.ready);
for (let f = 0; f < frames; f++) {
  await page.evaluate(t => window.tl.seek(t), f / FPS * 1000);
  await page.screenshot({ path: \`frame_\${String(f).padStart(4,'0')}.png\`, clip: { x: 0, y: 0, width: 200, height: 200 } });
}
await browser.close();
console.log('wrote ' + frames + ' frames');
EOF
echo "  wrote out/capture.mjs"

if command -v node &>/dev/null && [ -d "$OUT/node_modules/playwright" ]; then
  ( cd "$OUT" && node capture.mjs && command -v ffmpeg &>/dev/null && ffmpeg -y -framerate "$FPS" -i frame_%04d.png -pix_fmt yuv420p anime.mp4 ) && echo "  rendered out/anime.mp4"
else
  echo "  hint: cd $OUT && npm install animejs playwright && npx playwright install chromium && (command -v ffmpeg || brew install ffmpeg) && node capture.mjs && ffmpeg -framerate $FPS -i frame_%04d.png -pix_fmt yuv420p anime.mp4"
fi
