#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" games.title "OOTA")"

cat > "$OUT/scene.py" <<EOF
from pyray import *
set_config_flags(ConfigFlags.FLAG_WINDOW_HIDDEN)
init_window(320, 240, "h")
t = load_render_texture(320, 240)
begin_texture_mode(t)
clear_background(RAYWHITE)
draw_circle(160, 120, 80, RED)
draw_text("${TITLE}", 110, 110, 20, BLACK)
end_texture_mode()
img = load_image_from_texture(t.texture)
image_flip_vertical(img)  # FBO origin is bottom-left
export_image(img, "out.png")
close_window()
EOF
echo "  wrote out/scene.py"

if command -v python3 &>/dev/null && python3 -c "import pyray" &>/dev/null; then
  ( cd "$OUT" && python3 scene.py ) && echo "  rendered out/out.png"
else
  echo "  hint: pip install raylib  (or raylib-software for no-display) then python3 scene.py"
fi
