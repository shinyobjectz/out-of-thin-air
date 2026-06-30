#!/usr/bin/env bash
# generated draft — needs validation
# Revideo (headless Motion Canvas) project shell + minimal valid scene.
# Agent writes all scenes in out/src/; step never clobbers existing src/.
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_params.sh"
SESSION="$1" OUT="$2"
SLUG="$(basename "$(dirname "$SESSION")")"
TITLE="$(param "$SESSION" video.title "project")"
DUR="$(param "$SESSION" video.duration "10")"
FPS="$(param "$SESSION" video.fps "30")"
SAFE_ID="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
VOICE_WAV="$OUT/voice/voice.wav"

mkdir -p "$OUT/src" "$OUT/public/voice" "$OUT/output"

if [[ -f "$VOICE_WAV" ]]; then
  cp "$VOICE_WAV" "$OUT/public/voice/voice.wav"
  echo "  linked public/voice/voice.wav"
fi

HAS_SRC=false
if ls "$OUT/src"/*.tsx "$OUT/src"/*.ts 2>/dev/null | grep -q .; then
  HAS_SRC=true
  echo "  preserved agent-authored out/src/"
fi

if [[ "$HAS_SRC" == "false" ]]; then
  cat > "$OUT/src/example.tsx" <<EOF
import {makeScene2D, Txt} from '@revideo/2d';
import {createRef, waitFor} from '@revideo/core';

export default makeScene2D(function* (view) {
  const label = createRef<Txt>();
  view.add(<Txt ref={label} fill={'#fff'} fontSize={96} text={'${TITLE}'} />);
  yield* label().scale(1.15, 0.8).to(1, 0.8);
  yield* waitFor(${DUR});
});
EOF
  cat > "$OUT/src/project.ts" <<EOF
import {makeProject} from '@revideo/core';
import example from './example';

export default makeProject({
  scenes: [example],
});
EOF
  cat > "$OUT/render.mjs" <<'EOF'
import {renderVideo} from '@revideo/renderer';
const file = await renderVideo({projectFile: './src/project.ts', settings: {logProgress: true}});
console.log('OUT:', file);
EOF
  echo "  wrote out/src/project.ts + example.tsx + render.mjs"
fi

if [[ ! -f "$OUT/package.json" ]]; then
  cat > "$OUT/package.json" <<EOF
{
  "name": "oota-revideo",
  "private": true,
  "type": "module",
  "scripts": {
    "start": "revideo serve",
    "render": "node render.mjs"
  },
  "dependencies": {
    "@revideo/2d": "^0.4.0",
    "@revideo/core": "^0.4.0",
    "@revideo/renderer": "^0.4.0"
  },
  "devDependencies": {
    "@revideo/cli": "^0.4.0",
    "typescript": "^5.0.0"
  }
}
EOF
  echo "  wrote out/package.json"
fi

if [[ ! -f "$OUT/REVIDEO.md" ]] && [[ "$HAS_SRC" == "false" ]]; then
  cat > "$OUT/REVIDEO.md" <<EOF
# Revideo — agent-authored

Write scenes in \`src/\` (default project entry \`src/project.ts\`). Headless render.

1. Docs: https://docs.re.video/  |  Source (MIT): https://github.com/midrender/revideo
2. Scenes are \`makeScene2D\` generators; compose with \`makeProject\`
3. Voiceover: \`<Audio src={'/voice/voice.wav'} />\` (public/voice/)
4. Suggested: ${DUR}s @ ${FPS}fps; project id \`${SAFE_ID}\`

\`\`\`bash
npm install
node render.mjs        # headless → out/output/*.mp4
oota render ${SLUG}
\`\`\`
EOF
  echo "  wrote out/REVIDEO.md"
fi

# graceful-degrade headless render
if [[ -f "$OUT/node_modules/.bin/revideo" || -f "$OUT/node_modules/@revideo/renderer/package.json" ]]; then
  if command -v node &>/dev/null && (cd "$OUT" && node render.mjs); then
    echo "  rendered out/output/*.mp4"
  else
    echo "  hint: cd $OUT && npm install && node render.mjs"
  fi
else
  echo "  hint: cd $OUT && npm init @revideo@latest . && npm install, then node render.mjs (needs ffmpeg + Chromium)"
fi
