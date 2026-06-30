#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" data-visualization.title "OOTA smoke")"
EXT="$(param "$SESSION" data-visualization.ext "png")"

cat > "$OUT/plot.py" <<EOF
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams["font.family"] = "DejaVu Sans"

fig, ax = plt.subplots(figsize=(8, 6))
ax.plot([0, 1, 2, 3], [0, 1, 4, 9], marker="o")
ax.set_title("${TITLE}")
ax.set_xlabel("x")
ax.set_ylabel("y")

ext = "${EXT}"
out = "plot." + ext
meta = {"CreationDate": None} if ext in ("pdf", "svg") else None
fig.savefig(out, dpi=150, metadata=meta)
print("saved " + out)
EOF
echo "  wrote out/plot.py"

if command -v python3 &>/dev/null && python3 -c "import matplotlib" &>/dev/null; then
  ( cd "$OUT" && MPLBACKEND=Agg python3 plot.py ) && echo "  rendered out/plot.${EXT}"
else
  echo "  hint: python3 -m pip install -U 'matplotlib==3.11.0' then MPLBACKEND=Agg python3 out/plot.py"
fi
