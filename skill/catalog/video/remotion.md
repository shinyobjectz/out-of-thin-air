<!-- generated draft — needs validation -->
# remotion (video)

## Summary
Remotion renders deterministic, frame-accurate motion graphics by drawing each frame as a React component, capturing frames headlessly via Chromium, and stitching them with FFmpeg into MP4/WebM/GIF/etc. The primary deliverable is a video file (`.mp4`). Core authoring and rendering is JS/TS/React only; non-JS languages (Python, Go, Rust, PHP) drive Remotion solely as clients of the Lambda distributed renderer — they cannot render locally. Determinism comes from deriving all motion from the current frame index (`useCurrentFrame()` / `interpolate` / `spring`), never wall-clock time.

## Skills
| Skill / doc | Type | URL | Official | License |
|---|---|---|---|---|
| remotion-best-practices (bundled local skill) | anthropic-skill | file:///Users/shinyobjectz/.claude/skills/remotion/SKILL.md | official | unknown (vendored locally) |
| Remotion official docs / LLM guidance | official-docs | https://www.remotion.dev/docs/ | official | docs CC-style; Remotion code source-available with company license tier |
| Remotion AI / agent integration docs | official-docs | https://www.remotion.dev/docs/ai/ | official | docs |
| remotion-dev/remotion (GitHub) | repo | https://github.com/remotion-dev/remotion | official | Remotion License (free for individuals/small teams; paid Company License >3 employees) |

Attribution: Remotion by Jonny Burger / the Remotion dev team.

## Toolchains
| lang | install | invoke |
|---|---|---|
| JS/TS (React) — PRIMARY, authors + renders locally | `npm i remotion @remotion/cli @remotion/renderer` | `npx remotion render <entry> <CompId> out.mp4`; or `renderMedia()` / `renderStill()` from `@remotion/renderer` in Node |
| native CLI | `npm i @remotion/cli` | `npx remotion render`, `npx remotion still`, `npx remotion studio`, `npx remotion compositions`, `npx remotion lambda` |
| Python (Lambda remote only) | `pip install remotion-lambda` | `RemotionClient` + `RenderMediaParams` / `RenderStillParams` against a deployed serve URL |
| Go (Lambda remote only) | `go get github.com/remotion-dev/lambda-go-sdk` | Lambda client SDK — triggers renders only |
| Rust (Lambda remote only) | `cargo add remotionlambda` | Lambda client SDK — triggers renders only |
| PHP (Lambda remote only) | `composer require remotion/lambda-php` | Lambda client SDK — triggers renders only |

Notes:
- Keep all `@remotion/*` packages pinned to one exact version.
- Requires Node.js >=18; Chromium is auto-downloaded on first render.
- The Lambda SDKs (Python/Go/Rust/PHP) require a prior `npx remotion lambda` deploy from a JS project; they cannot render locally.

## Artifact kind
`video` — the universal shell plays the rendered `.mp4` directly with a `<video>` tag.

## Validation
- **install**: `npx create-video@latest --blank my-vid && cd my-vid && npm install`
- **smoke**: `npx remotion render src/index.ts HelloWorld out/video.mp4`
- **expect**: Headless Chromium downloads on first run, frames render, FFmpeg muxes → `out/video.mp4` (an H.264 MP4) is written. Works headless on macOS (no display server). Use the composition id reported by `npx remotion compositions src/index.ts` (e.g. `HelloWorld` or `MyComp`).

## Wrapper params
Worth exposing on a render wrapper:
- entry file + composition id
- `--props` (JSON, validated by the composition's Zod schema) for data-driven variants
- `--frames` / duration
- `--fps`, `--width` / `--height` (or compute via `calculateMetadata`)
- `--codec` (h264/h265/vp8/vp9/prores/gif) and `--image-format`
- `--crf` / `--quality`
- `--concurrency`, `--scale`, `--muted`
- output path

## Component / explorer notes
Primary output is a standard `.mp4` — the default video artifact shell plays it with a `<video>` tag; no richer explorer is needed for the deliverable. A richer explorer (Remotion Studio, `npx remotion studio`) is only useful for interactive authoring/scrubbing, not for viewing the rendered result.
