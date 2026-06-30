#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" video.title "Hello Motion Canvas")"
FPS="$(param "$SESSION" video.fps "30")"
RES="$(param "$SESSION" video.resolution "1920x1080")"
EXPORTER="$(param "$SESSION" video.exporter "ffmpeg-mp4")"

WIDTH="${RES%x*}"
HEIGHT="${RES#*x}"

mkdir -p "$OUT/src/scenes"

# --- project entry (project.ts) ---
cat > "$OUT/src/project.ts" <<EOF
import {makeProject} from '@motion-canvas/core';
import {FfmpegExporter} from '@motion-canvas/ffmpeg';
import example from './scenes/example?scene';

export default makeProject({
  scenes: [example],
  // ffmpeg exporter yields .mp4; remove to fall back to PNG image sequence
  plugins: [],
});
EOF

# --- scene source (.tsx generator function) ---
cat > "$OUT/src/scenes/example.tsx" <<EOF
import {makeScene2D, Txt} from '@motion-canvas/2d';
import {createRef, waitFor, all} from '@motion-canvas/core';

export default makeScene2D(function* (view) {
  const label = createRef<Txt>();
  view.add(
    <Txt ref={label} fontSize={96} fill={'#ffffff'} opacity={0}>
      ${TITLE}
    </Txt>,
  );

  yield* label().opacity(1, 1);
  yield* label().scale(1.2, 0.8).to(1, 0.8);
  yield* waitFor(1);
  yield* label().opacity(0, 1);
});
EOF

# --- minimal package.json so npm run serve works after install ---
cat > "$OUT/package.json" <<EOF
{
  "name": "motion-canvas-scene",
  "private": true,
  "scripts": {
    "serve": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "@motion-canvas/2d": "latest",
    "@motion-canvas/core": "latest",
    "@motion-canvas/ffmpeg": "latest"
  },
  "devDependencies": {
    "@motion-canvas/ui": "latest",
    "@motion-canvas/vite-plugin": "latest",
    "vite": "latest"
  }
}
EOF

# --- vite config wiring the motion-canvas plugin ---
cat > "$OUT/vite.config.ts" <<EOF
import {defineConfig} from 'vite';
import motionCanvas from '@motion-canvas/vite-plugin';

export default defineConfig({
  plugins: [
    motionCanvas({
      project: ['./src/project.ts'],
    }),
  ],
});
EOF

echo "  wrote out/src/project.ts"
echo "  wrote out/src/scenes/example.tsx"
echo "  wrote out/package.json"
echo "  wrote out/vite.config.ts"
echo "  config: ${WIDTH}x${HEIGHT} @ ${FPS}fps, exporter=${EXPORTER}"

# --- graceful render: motion-canvas is browser-driven; no headless render CLI ---
if command -v npm &>/dev/null; then
  echo "  hint: cd \"$OUT\" && npm install && npm install --save @motion-canvas/ffmpeg && npm run serve"
  echo "  hint: open http://localhost:9000 and click RENDER (output -> ./output; .mp4 via ffmpeg exporter)"
  echo "  note: no headless render CLI as of mid-2026 (issues #415/#1218) — CI needs a community Puppeteer driver"
else
  echo "  hint: install Node.js (>=16) + npm, then: npm init @motion-canvas@latest -- --template typescript"
fi
