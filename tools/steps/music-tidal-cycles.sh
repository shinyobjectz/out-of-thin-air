#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" music.title "Tidal Smoke")"
CPS="$(param "$SESSION" music.cps "0.5625")"
CYCLES="$(param "$SESSION" music.cycles "8")"
SAMPLEBANK="$(param "$SESSION" music.samplebank "default")"
CHANNELS="$(param "$SESSION" music.channels "2")"
BACKEND="$(param "$SESSION" music.backend "superdirt")"

mkdir -p "$OUT/src"

# minimal valid Tidal pattern scaffold
cat > "$OUT/src/pattern.tidal" <<EOF
-- $TITLE
-- sample bank: $SAMPLEBANK | cps: $CPS | render cycles: $CYCLES
setcps ($CPS)

d1 \$ sound "bd sn hh sn"
EOF
echo "  wrote out/src/pattern.tidal"

# SuperCollider boot/record script (headless render path)
cat > "$OUT/render.scd" <<EOF
// headless SuperDirt boot + record -> out/tidal.wav
(
SuperDirt.start;
s.waitForBoot {
    s.record("$OUT/tidal.wav", numChannels: $CHANNELS);
    // send pattern from GHCi Tidal, let it run, then s.stopRecording
};
)
EOF
echo "  wrote out/render.scd"

# graceful render
if [ "$BACKEND" = "superdirt" ] && command -v sclang &>/dev/null; then
  echo "  sclang found — boot SuperDirt + GHCi Tidal to render:"
  echo "    sclang -i tidal $OUT/render.scd   # then send: d1 \$ sound \"bd sn hh sn\""
  echo "    (run ~$CYCLES cycles, then s.stopRecording -> out/tidal.wav)"
  echo "  hint: full headless audio needs a working/virtual audio device (BlackHole)"
elif [ "$BACKEND" = "strudel" ] && command -v npm &>/dev/null; then
  echo "  hint: npm install @strudel/core @strudel/web; render src/pattern.tidal offline to out/tidal.wav"
else
  echo "  hint: brew install --cask supercollider && brew install ghc cabal-install"
  echo "        cabal update && cabal install tidal"
  echo "        in SuperCollider GUI: Quarks.install(\"SuperDirt\"); thisProcess.recompile()"
  echo "        then: sclang -i tidal $OUT/render.scd  (record) + GHCi Tidal (pattern)"
fi
