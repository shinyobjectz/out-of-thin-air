#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" cad.title "model")"
FORMAT="$(param "$SESSION" cad.format "stl")"
FN="$(param "$SESSION" cad.fn "48")"
IMGSIZE="$(param "$SESSION" cad.imgsize "800,600")"
PROJECTION="$(param "$SESSION" cad.projection "perspective")"

mkdir -p "$OUT/src"

cat > "$OUT/src/model.scad" <<EOF
// $TITLE — parametric OpenSCAD model
\$fn = $FN;

size = 20;       // overridable: openscad -D size=30
hole = 8;

difference() {
  cube([size, size, size], center = true);
  cylinder(h = size + 2, d = hole, center = true);
}
EOF
echo "  wrote out/src/model.scad"

# resolve the openscad CLI (macOS app bundle or PATH)
SCAD=""
if command -v openscad &>/dev/null; then
  SCAD="openscad"
elif [ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]; then
  SCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
fi

if [ -n "$SCAD" ]; then
  if [ "$FORMAT" = "png" ]; then
    "$SCAD" -o "$OUT/model.png" "$OUT/src/model.scad" \
      --imgsize="$IMGSIZE" --projection="$PROJECTION" \
      --camera=0,0,0,55,0,25,140
    echo "  rendered out/model.png"
  else
    "$SCAD" --render -o "$OUT/model.$FORMAT" "$OUT/src/model.scad"
    echo "  rendered out/model.$FORMAT"
  fi
else
  echo "  hint: brew install --cask openscad  (macOS) | apt install openscad  (Linux)"
  echo "  hint: openscad --render -o out/model.$FORMAT out/src/model.scad"
fi
