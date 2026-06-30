#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" shadertoy.title "Untitled")"
WIDTH="$(param "$SESSION" shadertoy.width "640")"
HEIGHT="$(param "$SESSION" shadertoy.height "360")"
TIME="$(param "$SESSION" shadertoy.time "1.0")"
FRAME="$(param "$SESSION" shadertoy.frame "60")"

cat > "$OUT/shader.glsl" <<EOF
// $TITLE — Shadertoy GLSL ES single-pass fragment shader
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = vec3(uv, 0.5 + 0.5 * sin(iTime));
    fragColor = vec4(col, 1.0);
}
EOF
echo "  wrote out/shader.glsl"

VENV=/tmp/stv
if [ -x "$VENV/bin/python" ] && "$VENV/bin/python" -c "import wgpu_shadertoy" &>/dev/null; then
  "$VENV/bin/python" - "$OUT/shader.glsl" "$OUT/shader.png" "$WIDTH" "$HEIGHT" "$TIME" "$FRAME" <<'PY'
import sys
from wgpu_shadertoy import Shadertoy
import numpy as np
from PIL import Image
src, dst, w, h, t, fr = sys.argv[1:7]
code = open(src).read()
s = Shadertoy(code, resolution=(int(w), int(h)), offscreen=True)
f = s.snapshot(time_float=float(t), frame=int(fr))
Image.fromarray(np.asarray(f)).save(dst)
PY
  echo "  rendered out/shader.png"
else
  echo "  hint: python3 -m venv /tmp/stv && /tmp/stv/bin/pip install wgpu-shadertoy pillow numpy"
  echo "  then: /tmp/stv/bin/python -c \"from wgpu_shadertoy import Shadertoy; import numpy as np; from PIL import Image; code=open('$OUT/shader.glsl').read(); s=Shadertoy(code, resolution=($WIDTH,$HEIGHT), offscreen=True); f=s.snapshot(time_float=$TIME, frame=$FRAME); Image.fromarray(np.asarray(f)).save('$OUT/shader.png')\""
fi
