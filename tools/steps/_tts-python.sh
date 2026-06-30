#!/usr/bin/env bash
# Prefer project TTS venv when present (Python 3.12 + kokoro-onnx).
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/../.." && pwd)"
VENV="$PROJECT/.venv-tts"
if [[ -x "$VENV/bin/python" ]]; then
  echo "$VENV/bin/python"
elif command -v python3.12 >/dev/null 2>&1; then
  echo "python3.12"
else
  echo "python3"
fi
