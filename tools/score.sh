#!/usr/bin/env bash
# Score an eval scenario against rubric.work checkpoints.
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SCENARIO="${1:?usage: score.sh <scenario-id>}"
RUBRIC="$PROJECT/eval/scenarios/$SCENARIO/rubric.work"
[[ -f "$RUBRIC" ]] || { echo "no rubric: $RUBRIC" >&2; exit 1; }

pass=0
fail=0
total=0

check_path() {
  local id="$1" rel="$2" pattern="${3:-}" min_bytes="${4:-0}"
  local path="$PROJECT/$rel"
  total=$((total + 1))
  if [[ ! -e "$path" ]]; then
    echo "FAIL [$id] missing: $rel"
    fail=$((fail + 1))
    return
  fi
  if [[ -n "$pattern" ]] && ! grep -q "$pattern" "$path" 2>/dev/null; then
    echo "FAIL [$id] grep '$pattern' not in $rel"
    fail=$((fail + 1))
    return
  fi
  if [[ "$min_bytes" -gt 0 ]]; then
    local sz
    sz=$(wc -c < "$path" | tr -d ' ')
    if (( sz < min_bytes )); then
      echo "FAIL [$id] $rel too small ($sz < $min_bytes)"
      fail=$((fail + 1))
      return
    fi
  fi
  echo "PASS [$id] $rel"
  pass=$((pass + 1))
}

check_cmd() {
  local id="$1" cmd="$2" pattern="$3"
  total=$((total + 1))
  local out
  out="$(cd "$PROJECT" && eval "$cmd" 2>&1)" || true
  if echo "$out" | grep -q "$pattern"; then
    echo "PASS [$id] $pattern"
    pass=$((pass + 1))
  else
    echo "FAIL [$id] expected '$pattern' from: $cmd"
    fail=$((fail + 1))
  fi
}

while IFS=$'\t' read -r id kind arg1 arg2 arg3; do
  [[ -z "$id" ]] && continue
  if [[ "$kind" == "path" ]]; then
    check_path "$id" "$arg1" "$arg2" "${arg3:-0}"
  elif [[ "$kind" == "cmd" ]]; then
    check_cmd "$id" "$arg1" "$arg2"
  fi
done < <(awk '
  /^checkpoint :/ { id=$0; sub(/^checkpoint :/, "", id); sub(/ do$/, "", id); path=cmd=grep_p=min_b="" }
  /^  path:/ { sub(/^  path: /, ""); path=$0 }
  /^  cmd:/ { sub(/^  cmd: /, ""); gsub(/^"/, "", $0); gsub(/"$/, "", $0); cmd=$0 }
  /^  grep:/ { sub(/^  grep: /, ""); gsub(/^"/, ""); gsub(/"$/, "", $0); grep_p=$0 }
  /^  min_bytes:/ { min_b=$2 }
  /^end$/ && id != "" {
    if (path != "") print id "\tpath\t" path "\t" grep_p "\t" min_b
    else if (cmd != "") print id "\tcmd\t" cmd "\t" grep_p
    id=""
  }
' "$RUBRIC")

echo "---"
echo "score: $pass/$total passed"
[[ "$fail" -eq 0 ]]
