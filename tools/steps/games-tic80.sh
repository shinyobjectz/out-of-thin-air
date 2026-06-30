#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "TIC-80 Game")"
SCRIPT="$(param "$SESSION" games.script "lua")"
EXPORT="$(param "$SESSION" games.export "html")"
SCALE="$(param "$SESSION" games.scale "1")"
BG="$(param "$SESSION" games.bg "13")"

mkdir -p "$OUT/src"

# minimal valid Lua cart: clears screen, prints title, draws a bouncing dot
cat > "$OUT/src/game.lua" <<EOF
-- ${TITLE} — TIC-80 cart (lua)
-- title: ${TITLE}
-- script: ${SCRIPT}
local t=0
function TIC()
 cls(${BG})
 t=t+1
 local x=120+math.floor(math.sin(t/30)*100)
 local y=68+math.floor(math.cos(t/20)*50)
 circ(x,y,4,12)
 print("${TITLE}",80,8,15)
 print("arrows/btn to play",64,120,14)
end
EOF

echo "  wrote out/src/game.lua"

# graceful render: export via headless tic80 CLI if present, else hint
if command -v tic80 &>/dev/null; then
  tic80 --cli --skip --scale "${SCALE}" --fs "$OUT" \
    --cmd "load src/game.lua & export ${EXPORT} ${EXPORT}-out & exit" \
    && echo "  rendered out/${EXPORT}-out (export target: ${EXPORT})"
else
  echo "  hint: brew install tic80 (or build from source: git clone --recursive https://github.com/nesbox/TIC-80 && cd TIC-80/build && cmake .. && make)"
  echo "        then: tic80 --cli --skip --fs $OUT --cmd \"load src/game.lua & export ${EXPORT} ${EXPORT}-out & exit\""
  echo "        NOTE: free official build may refuse export (PRO feature); source build exports freely"
fi
