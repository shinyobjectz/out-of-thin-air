#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" advertising-creative.title "OOTA")"
FORMAT="$(param "$SESSION" advertising-creative.format "png")"

# Deterministic, version-controllable source: HTML + CSS fragment.
cat > "$OUT/creative.html" <<EOF
<div class="card">$TITLE</div>
<style>
.card {
  font-family: sans-serif;
  font-size: 48px;
  padding: 40px;
  background: #111;
  color: #fff;
}
</style>
EOF
echo "  wrote out/creative.html"

# Render via HCTI (hosted SaaS — needs HCTI_USER/HCTI_KEY + network, NOT local).
if command -v curl &>/dev/null && [ -n "${HCTI_USER:-}" ] && [ -n "${HCTI_KEY:-}" ]; then
  HTML="$(cat "$OUT/creative.html")"
  ID=$(curl -s -X POST https://hcti.io/v1/image -u "$HCTI_USER:$HCTI_KEY" \
    -H 'Content-Type: application/json' \
    -d "$(python3 -c 'import json,sys;print(json.dumps({"html":sys.argv[1]}))' "$HTML")" \
    | python3 -c 'import sys,json;print(json.load(sys.stdin)["id"])')
  curl -s "https://hcti.io/v1/image/$ID.$FORMAT" -o "$OUT/creative.$FORMAT" \
    && echo "  rendered out/creative.$FORMAT"
else
  echo "  hint: export HCTI_USER and HCTI_KEY (from hcti.io, free tier 50/mo), then POST creative.html to https://hcti.io/v1/image and GET {id}.$FORMAT"
fi
