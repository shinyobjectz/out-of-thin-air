#!/usr/bin/env bash
# Generic scaffold for catalog tools without a dedicated step script yet.
set -euo pipefail
SESSION="$1" OUT="$2" CAT="$3" TOOL="$4"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" "${CAT}.title" "${CAT} output")"
OUTFILE="$OUT/${CAT}-${TOOL}.txt"
cat > "$OUTFILE" <<EOF
# ${CAT} / ${TOOL} — scaffold

Title: $TITLE

Add a step script at tools/steps/${CAT}-${TOOL}.sh
and a wrapper at projects/out-of-thin-air/wrappers/${CAT}-${TOOL}.work
EOF
echo "  wrote out/$(basename "$OUTFILE") (scaffold — no dedicated step script yet)"
