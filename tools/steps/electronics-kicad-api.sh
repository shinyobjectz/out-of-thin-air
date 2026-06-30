#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" electronics.title "RC Filter")"
R_VALUE="$(param "$SESSION" electronics.r_value "1k")"
C_VALUE="$(param "$SESSION" electronics.c_value "1u")"
EXPORT_FORMAT="$(param "$SESSION" electronics.export_format "svg")"

mkdir -p "$OUT"

# Minimal valid SKiDL circuit: oota schematic -> KiCad netlist
cat > "$OUT/circuit.py" <<EOF
# $TITLE — oota schematic (SKiDL)
from skidl import Part, Net, generate_netlist

r = Part('Device', 'R', value='$R_VALUE', footprint='Resistor_SMD:R_0805_2012Metric')
c = Part('Device', 'C', value='$C_VALUE', footprint='Capacitor_SMD:C_0805_2012Metric')

sig = Net('SIG')
sig += r[1], c[1]

generate_netlist(file_='rc.net')
EOF
echo "  wrote out/circuit.py"

# graceful render: emit the KiCad netlist via SKiDL if available
if command -v python3 &>/dev/null && python3 -c "import skidl" &>/dev/null; then
  ( cd "$OUT" && python3 circuit.py ) && echo "  rendered out/rc.net"
else
  echo "  hint: pip install skidl && (cd \"$OUT\" && python3 circuit.py)  # -> rc.net"
fi

# the visual artifact (svg) comes from kicad-cli plotting an actual board file
if command -v kicad-cli &>/dev/null; then
  if [ -f "$OUT/board.kicad_pcb" ]; then
    kicad-cli pcb export "$EXPORT_FORMAT" "$OUT/board.kicad_pcb" -o "$OUT/board.$EXPORT_FORMAT" \
      && echo "  rendered out/board.$EXPORT_FORMAT"
  else
    echo "  note: no out/board.kicad_pcb to plot; netlist (rc.net) is the headless deliverable"
  fi
else
  echo "  hint: brew install --cask kicad  then  kicad-cli pcb export $EXPORT_FORMAT board.kicad_pcb -o out/board.$EXPORT_FORMAT"
fi
