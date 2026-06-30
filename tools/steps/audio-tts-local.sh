#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_params.sh"
SESSION="$1" OUT="$2"
MODELS_SH="$(cd "$SCRIPT_DIR/.." && pwd)/models.sh"
TTS="$SCRIPT_DIR/_tts-synthesize.sh"
TEXT="$(param "$SESSION" audio.text "Hello from out-of-thin-air.")"
MODEL="$(param "$SESSION" audio.model "kokoro-tts")"
VOICE="$(param "$SESSION" audio.voice "")"
VOICE_DIR="$OUT/voice"
WAV="$VOICE_DIR/voice.wav"
mkdir -p "$VOICE_DIR"

if ! bash "$MODELS_SH" check "$MODEL" >/dev/null 2>&1; then
  bash "$MODELS_SH" check "$MODEL" || true
  cat > "$VOICE_DIR/README.txt" <<EOF
TTS deferred — hardware or model check failed.
Run: oota hardware && oota models check $MODEL
Script: $TEXT
EOF
  echo "  deferred TTS (see out/voice/README.txt)"
  exit 0
fi

echo "$TEXT" > "$VOICE_DIR/script.txt"

if engine="$(bash "$TTS" "$TEXT" "$WAV" "$MODEL" "$VOICE" 2>/dev/null)" && [[ -f "$WAV" ]]; then
  echo "  wrote out/voice/voice.wav ($engine)"
else
  cat > "$VOICE_DIR/README.txt" <<EOF
TTS runtime not installed yet.
  oota models download $MODEL
  pip install kokoro-onnx soundfile   # kokoro
  pip install piper-tts               # piper
On macOS, re-run uses built-in 'say' when HF runtimes are missing.
Script: $TEXT
EOF
  echo "  TTS failed — see out/voice/README.txt"
  exit 0
fi
