#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" 3d-shaders.title "scene")"
WIDTH="$(param "$SESSION" 3d-shaders.width "800")"
HEIGHT="$(param "$SESSION" 3d-shaders.height "600")"
ANTIALIAS="$(param "$SESSION" 3d-shaders.antialias "0.3")"
FORMAT="$(param "$SESSION" 3d-shaders.format "png")"

mkdir -p "$OUT/src"

cat > "$OUT/src/scene.pov" <<EOF
// $TITLE — POV-Ray SDL scene
#version 3.7;
global_settings { assumed_gamma 1.0 }

camera { location <0,2,-4> look_at <0,0,0> }
light_source { <5,8,-5> color rgb 1 }

sphere {
  <0,0,0>, 1
  texture {
    pigment { color rgb <0.2,0.5,0.9> }
    finish { phong 0.8 reflection 0.2 }
  }
}

plane {
  y, -1
  pigment { checker color rgb 1 color rgb 0.3 }
}
EOF
echo "  wrote out/src/scene.pov"

if command -v povray &>/dev/null; then
  povray +I"$OUT/src/scene.pov" +O"$OUT/scene.$FORMAT" \
    +W"$WIDTH" +H"$HEIGHT" -D +A"$ANTIALIAS"
  echo "  rendered out/scene.$FORMAT"
else
  echo "  hint: brew install povray  (macOS) | apt install povray  (Linux)"
  echo "  hint: povray +Iout/src/scene.pov +Oout/scene.$FORMAT +W$WIDTH +H$HEIGHT -D +A$ANTIALIAS"
fi
