#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" music.title "Untitled")"
INSTRUMENT="$(param "$SESSION" music.instrument "piano")"
TEMPO="$(param "$SESSION" music.tempo "120")"

mkdir -p "$OUT"

cat > "$OUT/song.alda" <<EOF
# $TITLE
(tempo! $TEMPO)
$INSTRUMENT: c d e f g a b > c
EOF
echo "  wrote out/song.alda"

# graceful render: export to MIDI if alda is present, else print install hint
if command -v alda &>/dev/null; then
  alda export -f "$OUT/song.alda" -o "$OUT/song.mid" && echo "  rendered out/song.mid"
else
  echo "  hint: brew install alda (player needs Java) then: alda export -f out/song.alda -o out/song.mid"
fi
