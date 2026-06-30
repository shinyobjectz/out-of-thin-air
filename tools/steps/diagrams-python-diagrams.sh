#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "Architecture")"
OUTFORMAT="$(param "$SESSION" diagrams.outformat "png")"
DIRECTION="$(param "$SESSION" diagrams.direction "LR")"

mkdir -p "$OUT/src"

cat > "$OUT/src/arch.py" <<EOF
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

with Diagram(
    "${TITLE}",
    filename="arch",
    outformat="${OUTFORMAT}",
    direction="${DIRECTION}",
    show=False,
):
    lb = ELB("lb")
    with Cluster("web tier"):
        web = [EC2("web1"), EC2("web2")]
    db = RDS("db")

    lb >> web >> db
EOF
echo "  wrote out/src/arch.py"

# graceful render: needs both python diagrams package and the graphviz 'dot' binary
if python3 -c "import diagrams" >/dev/null 2>&1 && command -v dot &>/dev/null; then
  ( cd "$OUT" && python3 src/arch.py ) && echo "  rendered out/arch.${OUTFORMAT}"
else
  echo "  hint: brew install graphviz && python3 -m pip install diagrams  then  python3 src/arch.py"
fi
