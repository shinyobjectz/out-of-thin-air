#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" fiction.title "My ChoiceScript Game")"
AUTHOR="$(param "$SESSION" fiction.author "Anonymous")"
TEST_MODE="$(param "$SESSION" fiction.test_mode "quicktest")"

# Lay out a minimal valid ChoiceScript game: mygame/scenes/startup.txt
mkdir -p "$OUT/mygame/scenes"
cat > "$OUT/mygame/scenes/startup.txt" <<EOF
*title $TITLE
*author $AUTHOR

*create courage 50

The door creaks open. Cold air spills into the hall.

*choice
  #Step through it.
    *set courage +10
    You square your shoulders and walk in.
    *goto ending
  #Turn back.
    *set courage -10
    You retreat into the warm light behind you.
    *goto ending

*label ending
Your courage stands at \${courage}.
*finish
EOF
echo "  wrote out/mygame/scenes/startup.txt"

# Graceful render: official toolchain is git-vendored Node scripts (compile.js).
if command -v node &>/dev/null && [ -f "compile.js" ]; then
  node compile.js mygame > "$OUT/game.html" && echo "  rendered out/game.html"
  if [ "$TEST_MODE" = "randomtest" ]; then
    node randomtest.js && echo "  randomtest passed" || echo "  randomtest reported issues"
  else
    node quicktest.js && echo "  quicktest passed" || echo "  quicktest reported issues"
  fi
else
  echo "  hint: git clone https://github.com/dfabulich/choicescript.git && cd choicescript"
  echo "  hint: place this scene set under web/mygame/scenes/, then: node compile.js mygame > game.html"
  echo "  hint: test with node quicktest.js (or node randomtest.js)"
fi
