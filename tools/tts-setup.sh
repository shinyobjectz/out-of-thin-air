#!/usr/bin/env bash
# One-time TTS setup: Python 3.12 venv + kokoro/piper deps (no API keys).
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$PROJECT/.venv-tts"
PY="${PY:-python3.12}"

if ! command -v "$PY" >/dev/null 2>&1; then
  echo "error: need python3.12 (brew install python@3.12)" >&2
  exit 1
fi

if [[ ! -x "$VENV/bin/python" ]]; then
  echo "→ creating $VENV"
  "$PY" -m venv "$VENV"
fi

echo "→ installing kokoro-onnx, soundfile, huggingface_hub, piper-tts"
"$VENV/bin/pip" install -q kokoro-onnx soundfile huggingface_hub piper-tts

echo "→ optional: oota models download kokoro-tts"
echo "ok: $VENV/bin/python ($( "$VENV/bin/python" -V ))"
