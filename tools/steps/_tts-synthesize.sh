#!/usr/bin/env bash
# Synthesize TEXT → WAV. Tries model-specific runtimes, then platform fallbacks.
set -euo pipefail

TEXT="${1:?text required}"
OUT_WAV="${2:?output wav path required}"
MODEL="${3:-kokoro-tts}"
VOICE="${4:-}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PROJECT="$ROOT"
MODEL_DIR="$PROJECT/cli/sessions/_models/$MODEL"

mkdir -p "$(dirname "$OUT_WAV")"

try_piper() {
  local piper_bin=""
  local venv="$PROJECT/.venv-tts/bin/piper"
  if [[ -x "$venv" ]]; then piper_bin="$venv"
  elif command -v piper >/dev/null 2>&1; then piper_bin=piper
  elif [[ -x "$HOME/Library/Python/3.9/bin/piper" ]]; then piper_bin="$HOME/Library/Python/3.9/bin/piper"
  elif [[ -x "$HOME/.local/bin/piper" ]]; then piper_bin="$HOME/.local/bin/piper"
  else return 1; fi
  local onnx
  onnx="$(find "$MODEL_DIR" -name '*.onnx' 2>/dev/null | head -1)"
  [[ -n "$onnx" ]] || return 1
  echo "$TEXT" | "$piper_bin" --model "$onnx" --output_file "$OUT_WAV"
}

try_kokoro_python() {
  local py
  py="$(bash "$(dirname "$0")/_tts-python.sh")"
  "$py" - <<PY
import sys
text = """${TEXT//\"/\\\"}"""
out = """$OUT_WAV"""
model_dir = """$MODEL_DIR"""
try:
    import soundfile as sf
    from kokoro_onnx import Kokoro
except ImportError:
    sys.exit(1)
import glob, os
onnx = glob.glob(os.path.join(model_dir, "**", "*.onnx"), recursive=True)
voices = glob.glob(os.path.join(model_dir, "**", "voices*.bin"), recursive=True)
if not onnx:
    sys.exit(1)
k = Kokoro(onnx[0], voices[0] if voices else None)
voice = "${VOICE}" or "af_sarah"
samples, sr = k.create(text, voice=voice, speed=1.0, lang="en-us")
sf.write(out, samples, sr)
PY
}

try_mac_say() {
  [[ "$(uname -s)" == "Darwin" ]] || return 1
  mkdir -p "$(dirname "$OUT_WAV")"
  local aiff="${OUT_WAV%.wav}.aiff"
  say -o "$aiff" "$TEXT"
  if command -v afconvert >/dev/null 2>&1; then
    afconvert -f WAVE -d LEI16 "$aiff" "$OUT_WAV"
    rm -f "$aiff"
  else
    mv "$aiff" "$OUT_WAV"
  fi
  [[ -f "$OUT_WAV" ]]
}

try_espeak() {
  command -v espeak-ng >/dev/null 2>&1 || command -v espeak >/dev/null 2>&1 || return 1
  local bin=espeak-ng
  command -v espeak-ng >/dev/null 2>&1 || bin=espeak
  "$bin" -w "$OUT_WAV" "$TEXT"
}

if [[ "$MODEL" == "piper-en" ]] && try_piper; then
  echo "piper"
  exit 0
fi

if [[ "$MODEL" == "kokoro-tts" ]] && try_kokoro_python; then
  echo "kokoro-onnx"
  exit 0
fi

if try_piper; then echo "piper"; exit 0; fi
if try_kokoro_python; then echo "kokoro-onnx"; exit 0; fi
if try_mac_say; then echo "mac-say-fallback"; exit 0; fi
if try_espeak; then echo "espeak-fallback"; exit 0; fi

exit 1
