#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" motion-graphics.title "Motion Canvas scene")"
DURATION="$(param "$SESSION" motion-graphics.duration "3")"
FPS="$(param "$SESSION" motion-graphics.fps "30")"
BG="$(param "$SESSION" motion-graphics.bg "#101014")"
WIDTH="$(param "$SESSION" motion-graphics.width "1920")"
HEIGHT="$(param "$SESSION" motion-graphics.height "1080")"
COLOR="$(param "$SESSION" motion-graphics.color "#22cc88")"

# minimal valid Motion Canvas scene (deterministic generator) + project entry
mkdir -p "$OUT/src/scenes"

cat > "$OUT/src/scenes/example.tsx" <<EOF
import {makeScene2D, Circle, Txt} from '@motion-canvas/2d';
import {all, createRef, waitFor} from '@motion-canvas/core';

// ${TITLE}
export default makeScene2D(function* (view) {
  const dot = createRef<Circle>();
  const label = createRef<Txt>();
  view.add(<Txt ref={label} text={'${TITLE}'} fill={'#ffffff'} y={-220} fontSize={64} />);
  view.add(<Circle ref={dot} size={120} fill={'${COLOR}'} x={-400} />);
  yield* all(
    dot().position.x(400, ${DURATION}),
    dot().scale(2, ${DURATION}),
  );
  yield* waitFor(0.5);
});
EOF

cat > "$OUT/src/project.ts" <<EOF
import {makeProject} from '@motion-canvas/core';
import example from './scenes/example?scene';

export default makeProject({
  scenes: [example],
  // Output: ${WIDTH}x${HEIGHT} @ ${FPS}fps, bg ${BG}.
  // Configure exporter in vite.config.ts (add ffmpeg() to plugins for MP4).
  variables: {fps: ${FPS}},
});
EOF

cat > "$OUT/vite.config.ts" <<EOF
import {defineConfig} from 'vite';
import motionCanvas from '@motion-canvas/vite-plugin';
import ffmpeg from '@motion-canvas/ffmpeg';

// ${WIDTH}x${HEIGHT} @ ${FPS}fps — ffmpeg() enables MP4 (H.264) export to ./output
export default defineConfig({
  plugins: [motionCanvas(), ffmpeg()],
});
EOF

echo "  wrote out/src/scenes/example.tsx, out/src/project.ts, out/vite.config.ts"

# graceful-degrade render: Motion Canvas has NO official headless CLI render (GH #415/#1218).
# If a project + the editor exist, hint how to render; otherwise emit install hint.
if command -v npm &>/dev/null && [ -f "$OUT/package.json" ]; then
  echo "  hint: cd out && npm install && npm start  → open localhost:9000, RENDER from Video Settings (FFmpeg exporter) → output/project.mp4"
  echo "  hint: headless render needs a Puppeteer/Playwright driver clicking RENDER (no official CLI yet)"
else
  echo "  hint: npm create @motion-canvas@latest my-anim -- --template typescript && cd my-anim && npm install && npm install --save @motion-canvas/ffmpeg"
  echo "        then copy out/src/* and out/vite.config.ts in, run npm start, and RENDER from the editor → output/project.mp4"
fi
