#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "Hello LÖVE")"
WIDTH="$(param "$SESSION" games.width "320")"
HEIGHT="$(param "$SESSION" games.height "240")"

mkdir -p "$OUT/src"

cat > "$OUT/src/main.lua" <<EOF
-- minimal valid LÖVE game
function love.conf(t)
  t.window.title = "${TITLE}"
  t.window.width = ${WIDTH}
  t.window.height = ${HEIGHT}
end

local t = 0
function love.load()
  love.window.setMode(${WIDTH}, ${HEIGHT})
end

function love.update(dt)
  t = t + dt
end

function love.draw()
  local x = (${WIDTH} / 2) + math.cos(t) * 60
  local y = (${HEIGHT} / 2) + math.sin(t) * 40
  love.graphics.print("${TITLE}", 20, 20)
  love.graphics.circle("fill", x, y, 16)
end

function love.keypressed(key)
  if key == "escape" then love.event.quit() end
end
EOF

# LÖVE looks for main.lua at the game-dir root; mirror it there too.
cp "$OUT/src/main.lua" "$OUT/main.lua"
echo "  wrote out/src/main.lua + out/main.lua"

# graceful render: native run / web export if tooling present, else hint
LOVE_BIN=""
if command -v love &>/dev/null; then
  LOVE_BIN="love"
elif [ -x "/Applications/love.app/Contents/MacOS/love" ]; then
  LOVE_BIN="/Applications/love.app/Contents/MacOS/love"
fi

if [ -n "$LOVE_BIN" ] && command -v love.js &>/dev/null && command -v zip &>/dev/null; then
  ( cd "$OUT" && zip -9 -qr game.love main.lua src ) \
    && love.js "$OUT/game.love" "$OUT/web" -c -t "$TITLE" \
    && echo "  rendered out/web/index.html (playable HTML export)"
elif [ -n "$LOVE_BIN" ]; then
  echo "  hint: love.js missing — run a native window with: $LOVE_BIN $OUT"
  echo "  hint: npm install -g love.js  then re-run for the playable HTML export"
else
  echo "  hint: brew install --cask love  (then: love $OUT)"
  echo "  hint: npm install -g love.js  for the playable HTML web export"
fi
