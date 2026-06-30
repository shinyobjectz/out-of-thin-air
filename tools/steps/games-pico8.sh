#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "Hi PICO-8")"
EXPORT_FORMAT="$(param "$SESSION" games.export_format "html")"
HEADLESS="$(param "$SESSION" games.headless_run "false")"
MINIFY="$(param "$SESSION" games.minify "false")"

mkdir -p "$OUT/src"

# minimal valid PICO-8 cartridge
cat > "$OUT/src/cart.p8" <<EOF
pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- $TITLE
function _draw()
 cls()
 print("hi",48,60,12)
end
EOF
echo "  wrote out/src/cart.p8"

# optional minify pass (shrinko8, no paid binary required)
if [ "$MINIFY" = "true" ]; then
  if command -v shrinko8 &>/dev/null; then
    shrinko8 "$OUT/src/cart.p8" "$OUT/src/cart.min.p8" --minify && echo "  minified out/src/cart.min.p8"
  elif command -v python3 &>/dev/null && [ -f shrinko8.py ]; then
    python3 shrinko8.py "$OUT/src/cart.p8" "$OUT/src/cart.min.p8" --minify && echo "  minified out/src/cart.min.p8"
  else
    echo "  hint: git clone https://github.com/thisismypassport/shrinko8 then python3 shrinko8.py src/cart.p8 out.p8 --minify"
  fi
fi

# graceful render: paid PICO-8 binary required to export the playable HTML
if command -v pico8 &>/dev/null; then
  if [ "$HEADLESS" = "true" ]; then
    pico8 -x "$OUT/src/cart.p8" && echo "  ran out/src/cart.p8 headless (-x)"
  fi
  pico8 "$OUT/src/cart.p8" -export "$OUT/game.$EXPORT_FORMAT" \
    && echo "  rendered out/game.$EXPORT_FORMAT"
else
  echo "  hint: purchase/install PICO-8 from https://www.lexaloffle.com/pico-8.php"
  echo "  hint: macOS: ln -s /Applications/PICO-8.app/Contents/MacOS/pico8 /usr/local/bin/pico8"
  echo "  hint: then: pico8 src/cart.p8 -export \"game.html\""
fi
