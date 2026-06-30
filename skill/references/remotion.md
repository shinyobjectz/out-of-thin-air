# Remotion (video)

The CLI prepares **project shell + assets** (npm, voice WAV in `public/voice/`).
You write **all** Remotion code in `cli/sessions/<slug>/out/src/` — no templates.

## Before writing video

1. Read [remotion-dev/skills](https://github.com/remotion-dev/skills) — `skills/remotion/SKILL.md`
2. Optional: [Remocn/remocn](https://github.com/Remocn/remocn) components via shadcn
3. Run chain steps you need first (e.g. `audio/tts-local` → voice file)

## Agent workflow

Portable (from project root):

```bash
just run <slug>       # shell + voice; does not overwrite existing src/
# edit cli/sessions/<slug>/out/src/*.tsx
just render <slug>
```

Monorepo root: `oota run` / `oota render`.

Composition id must match `video.title` in session params (e.g. `photosynthesis`).
Voice: `<Audio src={staticFile("voice/voice.wav")} />` — file is in `public/voice/`.

## Hard rule

**Do not** generate video from bash templates. Write React/TS compositions like
any Remotion project. The step script only scaffolds `package.json`, copies
voice assets, and writes `REMOTION.md` when `src/` is empty.
