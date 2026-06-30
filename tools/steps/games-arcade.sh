#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" games.title "OOTA")"

cat > "$OUT/scene.py" <<EOF
import os
os.environ["ARCADE_HEADLESS"] = "true"  # Linux/EGL only; macOS has no EGL headless backend
import arcade

W, H = 320, 240
win = arcade.open_window(W, H, "${TITLE}")
arcade.set_background_color(arcade.color.WHITE)
win.clear()
arcade.draw_rect_filled(arcade.rect.XYWH(W / 2, H / 2, 160, 160), arcade.color.AMAZON)
arcade.draw_text("${TITLE}", 20, H / 2, arcade.color.BLACK, 20)
arcade.get_image(0, 0, W, H).save("out.png")
win.close()
EOF
echo "  wrote out/scene.py"

if command -v python3 &>/dev/null && python3 -c "import arcade" &>/dev/null; then
  ( cd "$OUT" && ARCADE_HEADLESS=true python3 scene.py ) && echo "  rendered out/out.png"
else
  echo "  hint: pip install 'arcade==3.3.*' then ARCADE_HEADLESS=true python3 scene.py (Linux/EGL; macOS headless unsupported)"
fi
