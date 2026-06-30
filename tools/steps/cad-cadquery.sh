#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

W="$(param "$SESSION" cad.width "80")"
H="$(param "$SESSION" cad.height "40")"
D="$(param "$SESSION" cad.depth "20")"

cat > "$OUT/enclosure.py" <<EOF
"""CadQuery scaffold — run: python3 enclosure.py"""
try:
    import cadquery as cq
except ImportError:
    raise SystemExit("pip install cadquery")

result = (
    cq.Workplane("XY")
    .box($W, $H, $D)
    .edges("|Z").fillet(2)
)
cq.exporters.export(result, "$OUT/enclosure.step")
print("wrote $OUT/enclosure.step")
EOF

echo "  wrote out/enclosure.py"
if python3 -c "import cadquery" 2>/dev/null; then
  (cd "$OUT" && python3 enclosure.py) && echo "  exported out/enclosure.step"
else
  echo "  hint: pip install cadquery to export STEP"
fi
