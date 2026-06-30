#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" music.title "Beep")"
FORMAT="$(param "$SESSION" music.format "AIFF")"
SAMPLEFORMAT="$(param "$SESSION" music.sampleformat "int16")"
SAMPLERATE="$(param "$SESSION" music.samplerate "44100")"
DURATION="$(param "$SESSION" music.duration "2")"
CHANNELS="$(param "$SESSION" music.channels "2")"

# pick output extension from header format
case "$FORMAT" in
  WAV)  EXT="wav"  ;;
  FLAC) EXT="flac" ;;
  *)    EXT="aiff" ;;
esac

mkdir -p "$OUT/src"

# minimal VALID sclang NRT render scaffold
cat > "$OUT/src/render.scd" <<EOF
// $TITLE — SuperCollider NRT render (offline, headless)
(
var score = Score([
  [0.0, ['/d_recv', SynthDef(\\beep, { |out=0|
      Out.ar(out, SinOsc.ar(440) * EnvGen.kr(Env.perc(0.01, 1.8), doneAction:2) * 0.3 ! $CHANNELS);
  }).asBytes]],
  [0.0, ['/s_new', \\beep, 1000, 0, 0]],
  [$DURATION, ['/c_set', 0, 0]]
]);
score.recordNRT(
  nil,
  "$OUT/out.$EXT".standardizePath,
  sampleRate: $SAMPLERATE,
  headerFormat: "$FORMAT",
  sampleFormat: "$SAMPLEFORMAT",
  options: ServerOptions.new.numOutputBusChannels_($CHANNELS),
  duration: $DURATION,
  action: { 0.exit }
);
)
EOF
echo "  wrote out/src/render.scd"

# graceful render: render if sclang present, else print install hint
if command -v sclang &>/dev/null; then
  sclang "$OUT/src/render.scd" && echo "  rendered out/out.$EXT"
else
  echo "  hint: brew install --cask supercollider && ln -sf /Applications/SuperCollider.app/Contents/MacOS/sclang /usr/local/bin/sclang"
  echo "        then: sclang $OUT/src/render.scd  (writes out/out.$EXT)"
fi
