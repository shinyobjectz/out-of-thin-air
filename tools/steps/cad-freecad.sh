#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" cad.title "Box")"
FORMAT="$(param "$SESSION" cad.format "stl")"
TOL="$(param "$SESSION" cad.tolerance "0.1")"

mkdir -p "$OUT/src"

# minimal valid FreeCAD Python build script — makes a box and exports it
cat > "$OUT/src/model.py" <<EOF
import FreeCAD, Part

# build a parametric solid
box = Part.makeBox(10, 10, 10)

fmt = "$FORMAT"
out = "$OUT/$TITLE." + fmt
if fmt in ("step", "stp"):
    box.exportStep(out)
elif fmt in ("iges", "igs"):
    box.exportIges(out)
elif fmt == "brep":
    box.exportBrep(out)
else:  # mesh formats
    import Mesh
    Mesh.Mesh(box.tessellate($TOL)).write(out)
print("wrote " + out)
EOF
echo "  wrote out/src/model.py"

# graceful render: use freecadcmd if available, else print install hint
FCBIN=""
if command -v freecadcmd &>/dev/null; then
  FCBIN="freecadcmd"
elif command -v FreeCADCmd &>/dev/null; then
  FCBIN="FreeCADCmd"
elif [ -x "/Applications/FreeCAD.app/Contents/Resources/bin/FreeCADCmd" ]; then
  FCBIN="/Applications/FreeCAD.app/Contents/Resources/bin/FreeCADCmd"
fi

if [ -n "$FCBIN" ]; then
  "$FCBIN" "$OUT/src/model.py" && echo "  rendered out/$TITLE.$FORMAT"
else
  echo "  hint: brew install --cask freecad   then   FreeCADCmd $OUT/src/model.py"
fi
