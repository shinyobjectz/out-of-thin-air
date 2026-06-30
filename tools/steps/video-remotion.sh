#!/usr/bin/env bash
# Remotion project shell only — no composition templates. Agent writes all TSX
# in out/src/ following https://github.com/remotion-dev/skills
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
PROJECT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/_params.sh"
SESSION="$1" OUT="$2"
SLUG="$(basename "$(dirname "$SESSION")")"
TITLE="$(param "$SESSION" video.title "main")"
DUR="$(param "$SESSION" video.duration "10")"
FPS="$(param "$SESSION" video.fps "30")"
SAFE_ID="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
VOICE_WAV="$OUT/voice/voice.wav"

mkdir -p "$OUT/src" "$OUT/public/voice"

if [[ -f "$VOICE_WAV" ]]; then
  cp "$VOICE_WAV" "$OUT/public/voice/voice.wav"
  echo "  linked public/voice/voice.wav"
fi

HAS_SRC=false
if ls "$OUT/src"/*.tsx "$OUT/src"/*.ts 2>/dev/null | grep -q .; then
  HAS_SRC=true
  echo "  preserved agent-authored out/src/"
fi

if [[ ! -f "$OUT/package.json" ]]; then
  cat > "$OUT/package.json" <<EOF
{
  "name": "oota remotion",
  "private": true,
  "scripts": {
    "studio": "remotion studio src/index.ts",
    "render": "remotion render src/index.ts ${SAFE_ID} out/${SAFE_ID}.mp4"
  },
  "dependencies": {
    "@remotion/player": "^4.0.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "remotion": "^4.0.0"
  },
  "devDependencies": {
    "@remotion/cli": "^4.0.0",
    "@types/react": "^18.3.0",
    "typescript": "^5.0.0"
  }
}
EOF
fi

if [[ ! -f "$OUT/remotion.config.ts" ]]; then
  cat > "$OUT/remotion.config.ts" <<'EOF'
import { Config } from "@remotion/cli/config";
Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
EOF
fi

if [[ ! -f "$OUT/tsconfig.json" ]]; then
  cat > "$OUT/tsconfig.json" <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "jsx": "react-jsx",
    "strict": true,
    "moduleResolution": "bundler",
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
EOF
fi

if [[ ! -f "$(dirname "$SESSION")/player.work" ]] && [[ -f "$PROJECT/cli/_template/player.work" ]]; then
  cp "$PROJECT/cli/_template/player.work" "$(dirname "$SESSION")/player.work"
  echo "  wrote player.work — agent can add worktop form controls"
fi

if [[ ! -f "$OUT/src/player-site.tsx" ]] && [[ -f "$PROJECT/cli/_template/remotion-player-site.tsx" ]]; then
  cp "$PROJECT/cli/_template/remotion-player-site.tsx" "$OUT/src/player-site.tsx"
  echo "  wrote out/src/player-site.tsx — live preview shell"
fi

if [[ "$HAS_SRC" == "false" ]]; then
  cat > "$OUT/REMOTION.md" <<EOF
# Remotion — agent-authored

Write all compositions in \`src/\`. No templates — use Remotion fully.

1. Read https://github.com/remotion-dev/skills (skills/remotion/SKILL.md)
2. Optional components: https://github.com/Remocn/remocn
3. Voiceover: \`<Audio src={staticFile("voice/voice.wav")} />\` in public/voice/
4. Register root in src/index.ts; composition id: \`${SAFE_ID}\`
5. Suggested: ${DUR}s @ ${FPS}fps → $(( DUR * FPS )) frames

\`\`\`bash
npm install
npm run studio
oota render ${SLUG}
\`\`\`
EOF
  echo "  wrote out/REMOTION.md — agent writes src/*.tsx next"
else
  echo "  project shell ready (${SAFE_ID}, ${DUR}s @ ${FPS}fps)"
fi
