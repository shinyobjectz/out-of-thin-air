#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" fiction.title "My Visual Novel")"
VERSION="$(param "$SESSION" fiction.version "1.0")"

# Ren'Py projects live under game/; write a minimal valid script.rpy
mkdir -p "$OUT/game"

cat > "$OUT/game/script.rpy" <<EOF
# $TITLE — minimal Ren'Py visual novel script (.rpy DSL)

define e = Character("Eileen")

label start:
    scene black
    "Welcome to $TITLE."

    e "Hello! This is a Ren'Py visual novel."

    menu:
        "Where would you like to go?"

        "Take the left path.":
            jump left_path

        "Take the right path.":
            jump right_path

label left_path:
    e "You chose the left path. The story branches here."
    jump ending

label right_path:
    e "You chose the right path. A different branch."
    jump ending

label ending:
    e "Thanks for playing!"
    return
EOF

cat > "$OUT/game/options.rpy" <<EOF
# Author-time knobs
define config.name = _("$TITLE")
define config.version = "$VERSION"

define build.name = "$TITLE"
EOF

echo "  wrote out/game/script.rpy"
echo "  wrote out/game/options.rpy"

# graceful render: lint with renpy.sh if present; else print install hint
if command -v renpy.sh &>/dev/null; then
  renpy.sh "$OUT" lint && echo "  linted out/ (Ren'Py script OK)"
elif command -v renpy &>/dev/null; then
  renpy "$OUT" lint && echo "  linted out/ (Ren'Py script OK)"
else
  echo "  hint: no Ren'Py SDK on PATH. Install:"
  echo "    curl -L -o renpy-sdk.tar.bz2 https://www.renpy.org/dl/8.3.4/renpy-8.3.4-sdk.tar.bz2 && tar xjf renpy-sdk.tar.bz2"
  echo "  then lint:    ./renpy-8.3.4-sdk/renpy.sh $OUT lint"
  echo "  then build:   ./renpy-8.3.4-sdk/renpy.sh launcher distribute $OUT --destination $OUT/dist"
fi
