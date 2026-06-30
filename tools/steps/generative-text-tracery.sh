#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" generative-text.title "Tracery Sample")"
START="$(param "$SESSION" generative-text.start "#origin#")"
SAMPLES="$(param "$SESSION" generative-text.samples "5")"
SEED="$(param "$SESSION" generative-text.seed "")"

# minimal valid grammar scaffold (JSON) — agent/user edits this
cat > "$OUT/grammar.json" <<'EOF'
{
  "origin": "#greeting#, #place#!",
  "greeting": ["hello", "howdy", "hey"],
  "place": ["world", "moon", "#color# valley"],
  "color": ["green", "red"]
}
EOF
echo "  wrote out/grammar.json"

# graceful render: expand the grammar to text if python+tracery present, else hint
if command -v python3 &>/dev/null && python3 -c "import tracery" &>/dev/null; then
  python3 - "$OUT/grammar.json" "$OUT/output.txt" "$START" "$SAMPLES" "$SEED" <<'PY'
import json, sys, random
import tracery
from tracery.modifiers import base_english
gpath, opath, start, n, seed = sys.argv[1:6]
if seed:
    random.seed(seed)
rules = json.load(open(gpath))
g = tracery.Grammar(rules)
g.add_modifiers(base_english)
with open(opath, "w") as f:
    f.write("\n".join(g.flatten(start) for _ in range(int(n))))
PY
  echo "  rendered out/output.txt"
else
  echo "  hint: pip install tracery, then python -m tracery $OUT/grammar.json"
fi
