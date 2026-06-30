#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" 3d-shaders.title "Shader Sphere")"
ENGINE="$(param "$SESSION" 3d-shaders.engine "BLENDER_EEVEE_NEXT")"
SAMPLES="$(param "$SESSION" 3d-shaders.samples "64")"
COLOR="$(param "$SESSION" 3d-shaders.color "#3b82f6")"
RES="$(param "$SESSION" 3d-shaders.resolution "640x480")"

RES_X="${RES%x*}"
RES_Y="${RES#*x}"

# hex -> linear-ish RGB floats (sRGB 0..1 passed straight to Principled base color)
HEX="${COLOR#\#}"
R=$(printf '%d' "0x${HEX:0:2}"); G=$(printf '%d' "0x${HEX:2:2}"); B=$(printf '%d' "0x${HEX:4:2}")
RF=$(awk "BEGIN{print $R/255}"); GF=$(awk "BEGIN{print $G/255}"); BF=$(awk "BEGIN{print $B/255}")

cat > "$OUT/scene.py" <<EOF
# $TITLE — deterministic Blender shader scene
import bpy

bpy.ops.wm.read_factory_settings(use_empty=True)

# geometry
bpy.ops.mesh.primitive_uv_sphere_add()
obj = bpy.context.object
bpy.ops.object.shade_smooth()

# shader / material node graph
mat = bpy.data.materials.new("ShaderMat")
mat.use_nodes = True
bsdf = mat.node_tree.nodes.get("Principled BSDF")
bsdf.inputs["Base Color"].default_value = ($RF, $GF, $BF, 1.0)
bsdf.inputs["Roughness"].default_value = 0.3
bsdf.inputs["Metallic"].default_value = 0.6
obj.data.materials.append(mat)

# lights + camera
bpy.ops.object.light_add(type='SUN', location=(5, 5, 5))
bpy.ops.object.camera_add(location=(0, -6, 2), rotation=(1.2, 0, 0))
sc = bpy.context.scene
sc.camera = bpy.context.object

# render settings (deterministic)
sc.render.engine = '$ENGINE'
if sc.render.engine == 'CYCLES':
    sc.cycles.samples = $SAMPLES
    sc.cycles.seed = 0
sc.render.resolution_x = $RES_X
sc.render.resolution_y = $RES_Y
sc.render.image_settings.file_format = 'PNG'
sc.render.filepath = '$OUT/render.png'
bpy.ops.render.render(write_still=True)
EOF
echo "  wrote out/scene.py"

BLENDER_BIN="/Applications/Blender.app/Contents/MacOS/Blender"
if [ -x "$BLENDER_BIN" ]; then
  "$BLENDER_BIN" --background --factory-startup --python "$OUT/scene.py" && echo "  rendered out/render.png"
elif command -v blender &>/dev/null; then
  blender --background --factory-startup --python "$OUT/scene.py" && echo "  rendered out/render.png"
else
  echo "  hint: brew install --cask blender then /Applications/Blender.app/Contents/MacOS/Blender --background --factory-startup --python out/scene.py"
fi
