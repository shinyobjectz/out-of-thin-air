# audio

Voiceover/narration — local HF TTS when hardware allows.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [tts-local](./tts-local.md) | audio (24kHz mono WAV) | Python (kokoro/pytorch, kokoro-onnx/no-torch), CLI (kokoro-tts), JS/TS (kokoro-js), React/web (kokoro-js) | [hexgrad/kokoro](https://github.com/hexgrad/kokoro) | yes | ok | yes | yes |

## MULTI-TOOLCHAIN NOTES

- **tts-local** (Kokoro-82M): broadest coverage in this category.
  - Python: `pip install -U kokoro soundfile` (pytorch) or `pip install -U kokoro-onnx soundfile` (no-torch, lighter, CPU-only).
  - CLI: `pip install kokoro-tts`.
  - JS/TS: `npm i kokoro-js`.
  - React/web: `npm i kokoro-js` (runs in-browser).
  - No Go/native binding.

## VALIDATION ORDER

1. **tts-local** via `kokoro-onnx` (no-torch) — cheapest, most reliable: CPU-only, headless on macOS, no GPU/network at inference. Install pulls `kokoro-onnx soundfile` + two model files (kokoro-v1.0.onnx, voices-v1.0.bin). Smoke: synth "Hello from local TTS." to out.wav. Pytorch path heavier; only fall back if onnx fails.

## EXPLORER NEEDS

- None beyond the default artifact shell. Audio plays in the shell `<audio>` element (24kHz mono WAV). No richer explorer required.

## DOSSIERS

- [tts-local](./tts-local.md)
