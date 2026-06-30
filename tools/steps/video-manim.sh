#!/usr/bin/env bash
# generated draft — needs validation
# Manim (ManimCE) step — writes a minimal valid scene.py scaffold into out/src/
# (preserved if agent/user has edited it), then renders to MP4 if manim exists.
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_params.sh"
SESSION="$1" OUT="$2"

SCENE="$(param "$SESSION" video.scene "S")"
QUALITY="$(param "$SESSION" video.quality "l")"
FORMAT="$(param "$SESSION" video.format "mp4")"
FPS="$(param "$SESSION" video.fps "30")"

mkdir -p "$OUT/src"

if [[ -f "$OUT/src/scene.py" ]]; then
  echo "  preserved agent-authored out/src/scene.py"
else
  cat > "$OUT/src/scene.py" <<EOF
from manim import *


class ${SCENE}(Scene):
    def construct(self):
        title = Text("${SCENE}")
        circle = Circle()
        self.play(Write(title))
        self.play(title.animate.to_edge(UP))
        self.play(Create(circle))
        self.wait()
EOF
  echo "  wrote out/src/scene.py (Scene: ${SCENE})"
fi

if command -v manim &>/dev/null; then
  manim "-q${QUALITY}" --fps "$FPS" --format "$FORMAT" -o out "$OUT/src/scene.py" "$SCENE" \
    && echo "  rendered out/scene/*/out.${FORMAT}"
else
  echo "  hint: pip install manim && (command -v ffmpeg || brew install ffmpeg)"
  echo "  then: manim -q${QUALITY} --format ${FORMAT} -o out $OUT/src/scene.py ${SCENE}"
fi
