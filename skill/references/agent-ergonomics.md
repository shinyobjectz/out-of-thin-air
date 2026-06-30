# Agent ergonomics (field notes)

Tested on macOS Apple Silicon, 16GB RAM, 2026-06-29.

## What works well

| Step | Agent action | Result |
|------|--------------|--------|
| Discover skill | Read `skill/SKILL.md` | Clear 3-step workflow, paths table |
| Hardware gate | `oota hardware` | JSON, no nexus required |
| Model fit | `oota models list tts` | ok/defer columns — agent can pick safely |
| Run chain | `oota run remotion-voiceover` | Deterministic logs, `out/` layout |
| Offline route | Read `cli/router.work` | Works when nexus down (curl route fails) |
| Render video | `oota render remotion-voiceover` | MP4 in ~50s after npm install |

**Score: 8/10** for the `.work` → chain → out spine. An agent can execute without guessing.

## Friction found (and fixes)

### 1. TTS Python needs a venv (PEP 668)

`pip install kokoro-onnx` on system Python 3.9/3.12 fails on Homebrew macOS.

**Fix:** `oota tts-setup` → `projects/oota anything/.venv-tts` (Python 3.12).

**Agent rule:** Run setup once before HF TTS; macOS `say` fallback works without it.

### 2. Kokoro catalog default was broken until venv

`oota models download` silently “succeeded” when `huggingface_hub` missing on system Python.

**Fix:** Download now uses `.venv-tts/bin/python` when present.

### 3. Remotion scaffold was incomplete

Missing `src/index.ts`, voice not in `public/`, render script missing entry point.

**Fix:** `video-remotion.sh` now writes entry point, copies `voice.wav` → `public/voice/`.

### 4. No single “render” verb

Agent had to `cd out && npm install && npm run render` — easy to miss.

**Fix:** `oota render <slug>`.

### 5. Route API requires nexus

`oota route` fails with clear message when board is down. Agent must read `router.work` offline — document this in SKILL.

### 6. First Remotion render downloads ~94MB Chrome Headless Shell

Expected Remotion behavior; agent should warn user or cache. Subsequent renders fast.

## Recommended agent playbook (media)

```bash
oota hardware
oota tts-setup                    # once, for HF voice
oota models download kokoro-tts   # once, ~300MB
oota run remotion-voiceover
oota render remotion-voiceover    # → out/intro.mp4
```

Offline routing: grep `cli/router.work` for keywords → build `chain do` manually.

## Still rough

- **Remocn** — no step script; agent must run shadcn manually inside `out/`
- **remotion-dev/skills** — external clone; no pinned path in repo
- **music-tone-js** — ffmpeg placeholder works; Tone.js render needs `cd out/music && npm i`
- **`oota new`** — requirements only via worktop modal, not CLI flag
- **Session status** — `oota run` does not flip card status (API `/code-as/run` does)

## Verdict

Good agent surface for **orchestration** (route → session → chain → run). Weakest link was **environment setup** (Python venv, Remotion entry point) — now scripted. Next win: `oota new "Title" "requirements..."` and a Remocn step that patches `Intro.tsx`.
