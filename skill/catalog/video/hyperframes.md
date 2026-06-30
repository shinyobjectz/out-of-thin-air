<!-- generated draft — needs validation -->
# hyperframes (video)

## Summary

HyperFrames is HeyGen's HTML-driven video compositing CLI. An HTML file is the
source of truth: `data-*` timing attributes + a GSAP timeline + CSS drive clip
visibility, media playback, captions/TTS, audio-reactive effects, and scene
transitions. The framework then renders frame-accurate, deterministic MP4/WebM
via headless Chrome + FFmpeg. Distributed as the npm package `hyperframes`
(v0.7.21, by heygen-com). Single toolchain: Node.js >= 22 + FFmpeg, invoked via
`npx hyperframes`. Authoring is HTML/CSS/JS (GSAP); the **primary deliverable is
rendered video**.

Confidence: high — verified against installed first-party skills (hyperframes,
hyperframes-cli, hyperframes-registry) and the live npm registry entry.

## Skills

| Skill | Type | Official | License | URL |
|---|---|---|---|---|
| hyperframes (composition authoring) | anthropic-skill | yes | see repo (npm license field unset) | https://github.com/heygen-com/hyperframes |
| hyperframes-cli (init/lint/inspect/preview/render/transcribe/tts/doctor) | anthropic-skill | yes | see repo | https://github.com/heygen-com/hyperframes |
| hyperframes-registry (`hyperframes add` blocks/components, hyperframes.json) | anthropic-skill | yes | see repo | https://github.com/heygen-com/hyperframes |
| Project docs (`npx hyperframes docs`) | official-docs | yes | see repo | https://github.com/heygen-com/hyperframes#readme |

Attribution: all by **HeyGen (heygen-com)**. The authoring/CLI/registry skills
are installed locally (`~/.claude/skills/hyperframes*/SKILL.md`) and are copied
into a project by `hyperframes init`. `npx hyperframes docs` opens documentation
locally.

## Toolchains

| lang | install | invoke |
|---|---|---|
| JS/TS (Node CLI) | `npm i -g hyperframes` (or zero-install `npx hyperframes`); requires Node.js >= 22 + FFmpeg (`brew install ffmpeg`); Chrome managed via `hyperframes browser` | `npx hyperframes init <name>` then `npx hyperframes render` |

The npm package `hyperframes` (v0.7.21, heygen-com) is the only driver. No
Python/Go/Rust/React bindings — compositions are authored in HTML/CSS/JS with
GSAP timelines; reusable HTML blocks/components come from the registry via
`hyperframes add` (not a separate runtime).

## Artifact kind

**video** — the primary deliverable is a rendered MP4/WebM, rendered directly
by the universal `video` shell. Do NOT preview raw authoring HTML in a generic
HTML shell; it needs the HyperFrames runtime (timeline/clip-visibility engine).

## Validation

**Install**

```bash
npm i -g hyperframes          # needs Node >= 22 and FFmpeg (brew install ffmpeg)
npx hyperframes doctor        # verify Chrome / FFmpeg / Node / memory
```

**Smoke**

```bash
npx hyperframes init smoke-test --non-interactive
cd smoke-test
npx hyperframes lint
npx hyperframes render --quality draft --output out.mp4
```

**Expect**

- `doctor` reports Chrome/FFmpeg/Node/memory OK.
- `init` scaffolds `index.html` + `compositions/` + `hyperframes.json`.
- `lint` passes (no missing `data-composition-id`, no overlapping tracks).
- `render` drives headless Chrome frame-by-frame, muxes via FFmpeg, producing
  `out.mp4` (default: `renders/<name>_<timestamp>.mp4`).
- Render is already headless-Chrome based on macOS; use `--quality draft` for a
  fast smoke. If render fails, run `npx hyperframes doctor` first (usually
  missing FFmpeg or Chrome).

## Wrapper params

Render-side params worth exposing:

- `--output` — output path
- `--fps` — 24/30/60 (60 doubles render time)
- `--quality` — draft / standard / high
- `--format` — mp4 / webm (webm = transparency)
- `--workers` — 1-8 / auto (each spawns a Chrome instance)
- `--docker` — byte-identical reproducible output
- `--gpu`
- `--strict` / `--strict-all` — fail on lint errors / warnings

Authoring-side:

- `init --example/--template` — blank, warm-grain, play-mode, swiss-grid,
  vignelli, decision-tree, kinetic-type, product-promo, nyt-graph
- `--video` / `--audio` — attach media
- `--non-interactive` — CI/agents

Pipeline verbs: `lint`, `inspect` (`--samples/--at/--strict`), `transcribe`
(Whisper; `--model`, `--language`; imports srt/vtt/json), `tts` (`--voice` e.g.
`af_nova`/`bf_emma`, `--list`), `add` (registry blocks/components).

Visual identity is gated by an in-project DESIGN.md / visual-style.md
(HARD-GATE) — the wrapper should surface a style/preset selector.

## Component / explorer notes

The primary deliverable is rendered MP4/WebM, so the default `video` artifact
shell renders it directly. For interactive authoring use the built-in studio
(`npx hyperframes preview`, hot-reload, default port 3002) and `npx hyperframes
inspect` (headless-Chrome layout audit over the timeline). The richer explorer
is the HyperFrames studio itself, not a static HTML shell.
