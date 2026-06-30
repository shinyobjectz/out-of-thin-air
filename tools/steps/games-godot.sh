#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "smoke")"
FRAMES="$(param "$SESSION" games.frames "120")"
FPS="$(param "$SESSION" games.fps "60")"
RES="$(param "$SESSION" games.resolution "640x480")"

PROJ="$OUT/project"
mkdir -p "$PROJ"

cat > "$PROJ/project.godot" <<EOF
config_version=5
[application]
config/name="$TITLE"
run/main_scene="res://main.tscn"
[rendering]
renderer/rendering_method="gl_compatibility"
EOF

cat > "$PROJ/main.gd" <<'EOF'
extends Node2D
var f := 0
func _process(_d):
	queue_redraw()
	f += 1
func _draw():
	draw_circle(Vector2(320 + f, 240), 40, Color(1, 0.5, 0))
EOF

cat > "$PROJ/main.tscn" <<'EOF'
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://main.gd" id="1"]
[node name="Main" type="Node2D"]
script = ExtResource("1")
EOF

echo "  wrote out/project/ (project.godot + main.gd + main.tscn)"

GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
if [ -x "$GODOT" ] || command -v godot &>/dev/null; then
  BIN="$GODOT"; [ -x "$BIN" ] || BIN="$(command -v godot)"
  # NOTE: no --headless — Movie Maker needs a GPU render context.
  "$BIN" --path "$PROJ" --write-movie "$OUT/out.avi" --fixed-fps "$FPS" \
    --quit-after "$FRAMES" --resolution "$RES" && echo "  rendered out/out.avi"
else
  echo "  hint: brew install --cask godot then \"$GODOT\" --path out/project --write-movie out/out.avi --fixed-fps $FPS --quit-after $FRAMES --resolution $RES"
fi
