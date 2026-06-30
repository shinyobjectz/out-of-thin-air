#!/usr/bin/env bash
# Eval runner — reset seed, print blind prompt, optional score.
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
REPO="$(cd "$PROJECT/../.." && pwd)"
CMD="${1:?usage: eval.sh list|reset|prompt|run|score <scenario>}"
SCENARIO="${2:-}"

list_scenarios() {
  for d in "$PROJECT/eval/scenarios"/*/; do
    basename "$d"
  done
}

reset_scenario() {
  local id="$1"
  local seed="$PROJECT/eval/scenarios/$id/seed"
  local slug
  slug="$(awk '/slug:/ {print $2; exit}' "$seed/session.work" 2>/dev/null || echo "eval-$id")"
  slug="${slug//\"/}"
  local dest="$PROJECT/cli/sessions/$slug"
  rm -rf "$dest/out" "$dest/session.work"
  mkdir -p "$dest/out"
  cp "$seed/session.work" "$dest/session.work"
  echo "reset: $dest"
}

case "$CMD" in
  list)
    list_scenarios
    ;;
  reset)
    reset_scenario "$SCENARIO"
    ;;
  prompt)
    cat "$PROJECT/eval/scenarios/$SCENARIO/prompt.txt"
    echo ""
    echo "---"
    echo "Allowed context: projects/out-of-thin-air/skill/SKILL.md (+ references it links)"
    ;;
  run)
    # reset + chain (agent would write src between run and render)
    reset_scenario "$SCENARIO"
    slug="$(awk '/slug:/ {print $2; exit}' "$PROJECT/eval/scenarios/$SCENARIO/seed/session.work")"
    slug="${slug//\"/}"
    bash "$REPO/projects/out-of-thin-air/tools/run.sh" "$slug" 2>&1 || bash "$PROJECT/tools/run.sh" "$slug"
    ;;
  score)
    bash "$PROJECT/tools/score.sh" "$SCENARIO"
    ;;
  validate-reference)
    bash "$PROJECT/tools/validate-reference.sh"
    ;;
  *)
    echo "unknown: $CMD" >&2
    exit 1
    ;;
esac
