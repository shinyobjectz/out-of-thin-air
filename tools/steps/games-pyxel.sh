#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "OOTA")"
WIDTH="$(param "$SESSION" games.width "64")"
HEIGHT="$(param "$SESSION" games.height "64")"
CAPTURE_SCALE="$(param "$SESSION" games.capture_scale "2")"
CAPTURE_SEC="$(param "$SESSION" games.capture_sec "5")"
FRAMES="$(param "$SESSION" games.frames "60")"

mkdir -p "$OUT/src"

cat > "$OUT/src/game.py" <<EOF
# minimal valid, deterministic Pyxel game — runs ${FRAMES} frames then captures
import pyxel

pyxel.init(${WIDTH}, ${HEIGHT}, title="${TITLE}", capture_scale=${CAPTURE_SCALE}, capture_sec=${CAPTURE_SEC})

frame = 0

def update():
    global frame
    frame += 1
    if frame >= ${FRAMES}:
        pyxel.screencast("out")   # writes out.gif (rolling buffer)
        pyxel.screenshot("frame") # also writes frame.png (single frame)
        pyxel.quit()

def draw():
    pyxel.cls(0)
    # deterministic motion: position derived from frame count, no RNG/wall-clock
    x = ${WIDTH} // 2 + int(20 * pyxel.cos(frame * 6))
    y = ${HEIGHT} // 2 + int(14 * pyxel.sin(frame * 6))
    pyxel.rect(8, 8, ${WIDTH} - 16, ${HEIGHT} - 16, 1)
    pyxel.circ(x, y, 4, 11)
    pyxel.text(8, 4, "${TITLE}", 7)

pyxel.run(update, draw)
EOF
echo "  wrote out/src/game.py"

# graceful render: run the game to emit the GIF/PNG if pyxel present, else hint
if command -v pyxel &>/dev/null; then
  ( cd "$OUT" && pyxel run src/game.py ) \
    && echo "  rendered out/out.gif (+ out/frame.png)"
elif python3 -c 'import pyxel' &>/dev/null; then
  ( cd "$OUT" && python3 src/game.py ) \
    && echo "  rendered out/out.gif (+ out/frame.png)"
else
  echo "  hint: pip install pyxel   then: ( cd $OUT && pyxel run src/game.py )"
  echo "  hint: headless/deterministic — uvx pyxel-mcp and call its 'run' tool with src/game.py"
fi
