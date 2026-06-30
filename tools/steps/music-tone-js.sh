#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_params.sh"
SESSION="$1" OUT="$2"
BPM="$(param "$SESSION" music.bpm "120")"
KEY="$(param "$SESSION" music.key "C")"
DUR="$(param "$SESSION" music.duration "10")"
MUSIC_DIR="$OUT/music"
mkdir -p "$MUSIC_DIR"

cat > "$MUSIC_DIR/render.mjs" <<'EOF'
import { writeFileSync } from "node:fs";
import { Offline } from "tone";

const bpm = Number(process.env.MUSIC_BPM || 120);
const duration = Number(process.env.MUSIC_DURATION || 10);
const key = process.env.MUSIC_KEY || "C";

const notes = { C: "C4", D: "D4", E: "E4", F: "F4", G: "G4", A: "A4", B: "B4" };
const root = notes[key[0]] || "C4";

const buffer = await Offline(async ({ transport }) => {
  transport.bpm.value = bpm;
  const { Synth, Sequence } = await import("tone");
  const synth = new Synth({ oscillator: { type: "triangle" } }).toDestination();
  const seq = new Sequence(
    (time, note) => synth.triggerAttackRelease(note, "8n", time),
    [[root, "E4", "G4", root], ["G4", "B4", "D5", "G4"]],
    "4n"
  ).start(0);
  await transport.scheduleOnce(() => seq.dispose(), duration);
}, duration);

const ch = buffer.getChannelData(0);
const wavPath = new URL("./bed.wav", import.meta.url);
writeWav(wavPath.pathname, ch, buffer.sampleRate);
console.log("wrote bed.wav");

function writeWav(path, samples, sampleRate) {
  const n = samples.length;
  const buf = Buffer.alloc(44 + n * 2);
  buf.write("RIFF", 0); buf.writeUInt32LE(36 + n * 2, 4); buf.write("WAVE", 8);
  buf.write("fmt ", 12); buf.writeUInt32LE(16, 16); buf.writeUInt16LE(1, 20);
  buf.writeUInt16LE(1, 22); buf.writeUInt32LE(sampleRate, 24);
  buf.writeUInt32LE(sampleRate * 2, 28); buf.writeUInt16LE(2, 32); buf.writeUInt16LE(16, 34);
  buf.write("data", 36); buf.writeUInt32LE(n * 2, 40);
  for (let i = 0; i < n; i++) {
    const s = Math.max(-1, Math.min(1, samples[i]));
    buf.writeInt16LE(s < 0 ? s * 0x8000 : s * 0x7fff, 44 + i * 2);
  }
  writeFileSync(path, buf);
}
EOF

cat > "$MUSIC_DIR/package.json" <<EOF
{
  "name": "oota music-bed",
  "private": true,
  "type": "module",
  "dependencies": { "tone": "^15.0.4" }
}
EOF

if command -v ffmpeg >/dev/null 2>&1; then
  ffmpeg -y -hide_banner -loglevel error \
    -f lavfi -i "sine=frequency=440:duration=${DUR}" \
    "$MUSIC_DIR/bed.wav" 2>/dev/null || true
fi

if [[ -f "$MUSIC_DIR/bed.wav" ]]; then
  echo "  wrote out/music/bed.wav (ffmpeg placeholder — npm i && node render.mjs for Tone.js)"
else
  echo "  wrote out/music/render.mjs + package.json (run: cd out/music && npm i && node render.mjs)"
fi
