#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" 3d-shaders.title "Untitled Shader")"
WIDTH="$(param "$SESSION" 3d-shaders.width "1024")"
HEIGHT="$(param "$SESSION" 3d-shaders.height "1024")"
TIME="$(param "$SESSION" 3d-shaders.time "1")"

cat > "$OUT/shader.frag" <<EOF
// $TITLE
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform float u_time;
void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    gl_FragColor = vec4(st.x, st.y, 0.5 + 0.5 * sin(u_time), 1.0);
}
EOF
echo "  wrote out/shader.frag"

if command -v glslViewer &>/dev/null; then
  glslViewer "$OUT/shader.frag" -w "$WIDTH" -h "$HEIGHT" --headless -s "$TIME" -o "$OUT/shader.png" \
    && echo "  rendered out/shader.png"
else
  echo "  hint: build glslViewer from source (git clone --recursive https://github.com/patriciogonzalezvivo/glslViewer.git && brew install pkg-config cmake ncurses && cd glslViewer && mkdir build && cd build && cmake .. && make && sudo make install), then: glslViewer $OUT/shader.frag -w $WIDTH -h $HEIGHT --headless -s $TIME -o $OUT/shader.png"
fi
