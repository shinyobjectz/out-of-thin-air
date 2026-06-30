#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" notation.title "Untitled Score")"
FORMAT="$(param "$SESSION" notation.format "pdf")"
STAFF="$(param "$SESSION" notation.staff_size "20")"
MIDI="$(param "$SESSION" notation.midi "false")"

mkdir -p "$OUT/src"

MIDI_BLOCK=""
if [ "$MIDI" = "true" ]; then
  MIDI_BLOCK="    \\midi { }"
fi

cat > "$OUT/src/score.ly" <<EOF
\\version "2.24.0"

#(set-global-staff-size $STAFF)

\\header {
  title = "$TITLE"
}

\\score {
  \\new Staff {
    \\clef treble
    \\time 4/4
    { c'4 d' e' f' g'1 }
  }
  \\layout { }
$MIDI_BLOCK
}
EOF
echo "  wrote out/src/score.ly"

# graceful render: render if the lilypond CLI exists, else print an install hint
if command -v lilypond &>/dev/null; then
  FLAG="--pdf"
  case "$FORMAT" in
    png) FLAG="--png -dresolution=300" ;;
    svg) FLAG="--svg" ;;
    ps)  FLAG="--ps" ;;
    *)   FLAG="--pdf" ;;
  esac
  # shellcheck disable=SC2086
  lilypond $FLAG -dno-point-and-click -o "$OUT/score" "$OUT/src/score.ly" \
    && echo "  rendered out/score.$FORMAT"
else
  echo "  hint: brew install lilypond && lilypond --pdf -dno-point-and-click -o out/score out/src/score.ly"
fi
