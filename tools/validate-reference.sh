#!/usr/bin/env bash
# Score science-photosynthesis session (reference validation, not blind eval).
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="science-photosynthesis"
BASE="$PROJECT/cli/sessions/$SLUG/out"
pass=0 fail=0

check() {
  local name="$1" path="$2" pattern="${3:-}"
  if [[ ! -e "$path" ]]; then echo "FAIL $name"; fail=$((fail+1)); return; fi
  if [[ -n "$pattern" ]] && ! grep -q "$pattern" "$path" 2>/dev/null; then
    echo "FAIL $name (grep)"; fail=$((fail+1)); return
  fi
  echo "PASS $name"; pass=$((pass+1))
}

check voice.wav "$BASE/voice/voice.wav"
check public-voice "$BASE/public/voice/voice.wav"
check index.ts "$BASE/src/index.ts" registerRoot
check root.tsx "$BASE/src/Root.tsx" Composition
check photosynthesis.tsx "$BASE/src/Photosynthesis.tsx" Audio
check mp4 "$BASE/out/photosynthesis.mp4"
if [[ -f "$BASE/out/photosynthesis.mp4" ]]; then
  sz=$(wc -c < "$BASE/out/photosynthesis.mp4" | tr -d ' ')
  if (( sz > 100000 )); then echo "PASS mp4-size ($sz bytes)"; pass=$((pass+1)); else echo "FAIL mp4-size"; fail=$((fail+1)); fi
fi

echo "--- reference validation: $pass/$((pass+fail)) checks"
[[ "$fail" -eq 0 ]]
