<!-- generated draft — needs validation -->
# tts-local (audio)

## Summary
`tts-local` = running an open-weight Hugging Face TTS model fully on-device for voiceover/narration — no GPU, no cloud. The de-facto 2025-2026 pick is **Kokoro-82M** (`hexgrad/Kokoro-82M`, Apache-2.0): an 82M-param model that runs fast on CPU, headless, macOS/Apple-Silicon friendly. It ships in three independent ecosystems: the official PyTorch `kokoro` package, the torch-free ONNX-runtime `kokoro-onnx`, and `kokoro-js` (Transformers.js, browser+Node). 54 voices across ~8 languages. Primary deliverable is a 24kHz mono WAV file. Chatterbox (Resemble AI) is a heavier GPU-leaning alternative; Kokoro is the headless default. `tts-local` is a generic category label mapped here to the dominant concrete tool (Kokoro).

## Skills (attributed references)
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| hexgrad/kokoro (official repo + usage docs) | repo | official | Apache-2.0 | https://github.com/hexgrad/kokoro |
| hexgrad/Kokoro-82M model card | official-docs | official | Apache-2.0 | https://huggingface.co/hexgrad/Kokoro-82M |
| onnx-community/Kokoro-82M-v1.0-ONNX | official-docs | official | Apache-2.0 | https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX |
| thewh1teagle/kokoro-onnx | repo | community | MIT | https://github.com/thewh1teagle/kokoro-onnx |
| nazdridoy/kokoro-tts (full-featured CLI) | repo | community | Apache-2.0 | https://github.com/nazdridoy/kokoro-tts |
| kokoro-js (Transformers.js) | repo | official | Apache-2.0/MIT | https://www.npmjs.com/package/kokoro-js |

Attribution: Kokoro model + official Python package by **hexgrad**; ONNX weights by **onnx-community (HF)**; `kokoro-onnx` torch-free lib by **thewh1teagle**; full CLI by **nazdridoy**; `kokoro-js` JS/browser runtime by **Xenova / Hugging Face**. As of 2026-06 no dedicated Anthropic/Claude SKILL.md exists — use the official kokoro README as the agent guide.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (PyTorch, official) | `pip install -U kokoro soundfile` (+ `brew install espeak-ng`) | `from kokoro import KPipeline; p=KPipeline(lang_code='a'); for gs,ps,audio in p(text, voice='af_heart'): sf.write('out.wav', audio, 24000)` |
| Python (ONNX, no torch) | `pip install -U kokoro-onnx soundfile` (+ download `kokoro-v1.0.onnx` + `voices-v1.0.bin`) | `Kokoro(model,voices).create(text, voice='af_sarah', speed=1.0, lang='en-us') -> samples,sr` |
| Native CLI | `pip install kokoro-tts` (or `uv run kokoro-tts`); needs `kokoro-v1.0.onnx` + `voices-v1.0.bin` in cwd | `kokoro-tts input.txt out.wav --voice af_sarah --speed 1.2 --lang en-us` (txt/EPUB/PDF, voice blending, `--stream`) |
| JS/TS (Node + browser) | `npm i kokoro-js` | `const tts=await KokoroTTS.from_pretrained('onnx-community/Kokoro-82M-v1.0-ONNX',{dtype:'q8',device:'cpu'}); const audio=await tts.generate(text,{voice:'af_heart'}); audio.save('out.wav')` |
| React / web | `npm i kokoro-js` | same API; `device:'webgpu'` or `'wasm'`, 100% client-side. Wrap `generate()` in a worker to avoid blocking UI |

## Artifact kind
**audio** — primary deliverable is a 24kHz mono WAV file rendered by the universal shell's `<audio>` player.

## Validation
**install:**
```
python -m venv .venv && source .venv/bin/activate && pip install -U kokoro-onnx soundfile && \
curl -L -o kokoro-v1.0.onnx https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0/kokoro-v1.0.onnx && \
curl -L -o voices-v1.0.bin https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0/voices-v1.0.bin
```
**smoke:**
```
python -c "import soundfile as sf; from kokoro_onnx import Kokoro; k=Kokoro('kokoro-v1.0.onnx','voices-v1.0.bin'); s,sr=k.create('Hello from local TTS.', voice='af_sarah', speed=1.0, lang='en-us'); sf.write('out.wav', s, sr); print('wrote out.wav', sr)"
```
**expect:** Creates `out.wav` (~1-2s, 24kHz mono PCM) of spoken "Hello from local TTS." Runs CPU-only, headless on macOS (Apple Silicon fine). No network/GPU needed once model files are local.

## Wrapper params
Key params worth exposing:
- `text` — input text/narration.
- `voice` — `af_heart` / `af_sarah` / `am_adam` … (54 options).
- `lang` / `lang_code` — `'a'`=US English, `'b'`=UK, etc.
- `speed` — 0.5-2.0.
- `dtype`/quantization (ONNX/JS) — fp32/fp16/q8/q4 (speed vs quality).
- `device` (ONNX/JS) — cpu/wasm/webgpu.

Output sample rate fixed at 24kHz mono. Voice blending (weighted mix of two voices) available in the `kokoro-tts` CLI.

## Component / explorer notes
Primary deliverable is a WAV — the default audio artifact shell (simple `<audio>` player) renders it fine. A richer explorer is only worth it for per-voice/per-language switching or waveform display; for single-clip narration the basic player suffices.
