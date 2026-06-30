#!/usr/bin/env bash
# Run a code-as session's tool chain locally (polyglot — shells out to host CLIs).
set -euo pipefail

PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS="$(cd "$(dirname "$0")" && pwd)"
CLI="$PROJECT/cli"
SLUG="${1:?usage: run.sh <slug>}"
SESSION="$CLI/sessions/$SLUG/session.work"
OUT="$CLI/sessions/$SLUG/out"
STEPS="$TOOLS/steps"

if [[ ! -f "$SESSION" ]]; then
  echo "error: no session at $SESSION" >&2
  exit 1
fi

mkdir -p "$OUT"

STEPS_LIST=()
while IFS= read -r line; do
  [[ -n "$line" ]] && STEPS_LIST+=("$line")
done < <(
  awk '/^chain do$/,/^end$/ { if ($0 ~ /^[[:space:]]*[a-z]/ && $0 !~ /^chain/ && $0 !~ /^end$/) print $0 }' "$SESSION" \
    | sed -E 's/^[[:space:]]*([a-z0-9-]+):[[:space:]]*([a-z0-9-]+).*/\1 \2/'
)

if [[ ${#STEPS_LIST[@]} -eq 0 ]]; then
  echo "warn: empty chain — add steps in session.work or the worktop"
  exit 0
fi

echo "session: $SLUG"
echo "output:  $OUT"
echo "---"

for step in "${STEPS_LIST[@]}"; do
  [[ -z "$step" ]] && continue
  read -r CAT TOOL <<< "$step"
  script="$STEPS/${CAT}-${TOOL}.sh"
  echo "→ $CAT / $TOOL"
  if [[ -x "$script" ]] || [[ -f "$script" ]]; then
    bash "$script" "$SESSION" "$OUT"
  else
    echo "  skip: no step script at tools/steps/${CAT}-${TOOL}.sh"
    echo "  scaffold only — add a step script or wrapper in wrappers/"
  fi
  echo ""
done

echo "done."
