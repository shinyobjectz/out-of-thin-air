#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" fiction.title "My Branching Story")"
FORMAT="$(param "$SESSION" fiction.format "harlowe-3")"
START="$(param "$SESSION" fiction.start "You stand at a fork in the path.")"

mkdir -p "$OUT"
cat > "$OUT/story.twee" <<EOF
:: StoryTitle
$TITLE

:: Start
$START

Go [[left->Left]] or go [[right->Right]].

:: Left
You chose the left path and find a quiet meadow.

[[Start over->Start]]

:: Right
You chose the right path and find a dark cave.

[[Start over->Start]]
EOF
echo "  wrote out/story.twee"

# graceful render: compile to self-contained HTML if Tweego is present
if command -v tweego &>/dev/null; then
  tweego -f "$FORMAT" -o "$OUT/play.html" "$OUT/story.twee" && echo "  rendered out/play.html"
else
  echo "  hint: install Tweego from https://www.motoslave.net/tweego/ (keep storyformats/ alongside, or set TWEEGO_PATH),"
  echo "        then: tweego -f $FORMAT -o out/play.html out/story.twee"
fi
