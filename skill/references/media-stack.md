# Media stack (voice · music · video)

Remotion-first video with optional local HF models and code-as music libraries.

## When to use what

| Need | First choice | Fallback |
|------|--------------|----------|
| Video | Agent-authored Remotion in `out/src/` + [remotion-dev/skills](https://github.com/remotion-dev/skills) | hyperframes |
| Motion UI | [Remocn/remocn](https://github.com/Remocn/remocn) components | hand-rolled React |
| Voiceover | `audio/tts-local` + kokoro or piper | cloud API (out of scope) |
| Music bed | `music/tone-js` or sonic-pi | `oota models check musicgen-small` |
| Captions | whisper-base via models catalog | Groq (repo pipeline) |

## Hardware gate

Always run before downloading models:

```bash
oota hardware          # JSON: ram_gb, gpu, vram_gb, runtimes
oota models list tts   # ok vs defer:ram / defer:vram
oota models check kokoro-tts
oota models download kokoro-tts
```

Or with nexus: `GET /code-as/hardware`, `GET /code-as/models?task=tts`.

**Defer** means the CLI exits 2 and step scripts write `out/voice/README.txt`
instead of failing the whole chain. On macOS without HF runtimes, TTS falls back
to built-in `say` → `voice.wav`.

Detection uses `sysctl` / `/proc/meminfo` for RAM, `nvidia-smi` for CUDA VRAM,
Apple Silicon → `apple_mps`. Formats in catalog: **ONNX** (lightest CPU), **GGUF**
(whisper-cpp), **transformers**, **diffusers** (heavy video — usually defer).

## Upstream skills (hybrid)

Do **not** copy remotion-dev/skills into this repo wholesale. Point agents at:

- https://github.com/remotion-dev/skills — `skills/remotion/SKILL.md`
- https://github.com/Remocn/remocn — install per component via shadcn CLI

Project wrapper: `wrappers/video-remotion.work`. **No video templates** — CLI
scaffolds shell + assets only; agent writes all TSX.

## Files

- `media/models.work` — HF repo ids + min RAM/VRAM
- `media/libraries.work` — Remocn, Tone.js, Strudel, etc.
- `examples/remotion-voiceover.work` — sample chain
- `cli/sessions/remotion-voiceover/` — runnable golden path
