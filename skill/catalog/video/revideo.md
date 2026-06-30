<!-- generated draft — needs validation -->
# revideo (video)

## Summary
Revideo is an open-source TypeScript framework for programmatic video — a fork of Motion Canvas that adds headless rendering, audio support, and a library-first/API-first design. Animations are authored as deterministic TS scene generators (`makeScene2D` + `yield*` tweens) composed into a project (`makeProject`); rendering is exposed as a function call (`renderVideo` from `@revideo/renderer`) or a CLI (`npm run render`), driving headless Chromium (auto via puppeteer) + ffmpeg to emit an `.mp4`. Unlike upstream Motion Canvas, headless/CI rendering is first-class — no browser-UI click required — which fits OOTA's deterministic, version-controllable, headless-render model. Self-hosted Node rendering API is free and unrestricted. MIT licensed. Note: repo moved from `havenhq/redotvideo` to `midrender/revideo` (re.video / midrender.com). Primary deliverable: **video (MP4)**.

## Skills
| Skill | Type | Official | URL | License |
|-------|------|----------|-----|---------|
| (none for Revideo) | none | n/a | https://docs.re.video/ | n/a |
| Revideo official docs (llms reference) | docs | yes | https://docs.re.video/ | docs |
| midrender/revideo (GitHub source + examples) | repo | yes | https://github.com/midrender/revideo | MIT |

Attribution: no official Anthropic/Claude skill exists for Revideo. The local environment ships a `remotion` skill but that targets Remotion, a different framework. Docs by midrender (Revideo project) at docs.re.video; source `midrender/revideo` (MIT), examples at github.com/redotvideo/revideo-examples.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| TypeScript/JavaScript (Node >=16, 18+ recommended) | `npm init @revideo@latest my-revideo -- --template default && cd my-revideo && npm install` | `npm run render` (CLI) or `import {renderVideo} from '@revideo/renderer'` from a Node script; `npm start` for the dev editor |

Packages: `@revideo/core`, `@revideo/2d`, `@revideo/renderer`, `@revideo/cli`. Scaffold with `npm init @revideo@latest` (fallback `npm exec @revideo/create@latest`). Requires headless Chromium (fetched by puppeteer on install) and ffmpeg available. Deployable as a rendering API (e.g. Google Cloud Run). Telemetry opt-out: `DISABLE_TELEMETRY=true`.

## Artifact kind
**video** — primary output is a standard `.mp4` (headless Chromium frames muxed by ffmpeg), written under `./output` (e.g. `output/project.mp4`). Can also export image sequences / stills.

## Validation
- **install**: `npm init @revideo@latest revideo-smoke -- --template default && cd revideo-smoke && npm install`
- **smoke**: write a render script and run it headless:
  ```bash
  cat > render.mjs <<'EOF'
  import {renderVideo} from '@revideo/renderer';
  const file = await renderVideo({projectFile:'./src/project.ts', settings:{logProgress:true}});
  console.log('OUT:', file);
  EOF
  node render.mjs   # or simply: npm run render
  ```
- **expect**: Headless Chromium renders frames, ffmpeg muxes them, and an `.mp4` is written under `./output` (path printed as `OUT: .../output/project.mp4`). Exit code 0; ffmpeg + Chromium run without a display on macOS.

## Wrapper params
- composition/project file id
- resolution / scale
- frame rate (24/30/60)
- duration hint (seconds)
- exporter (mp4 vs image sequence)
- audio source (sync via the `Audio` tag)
- render variables / params (dynamic inputs for templating)

Scene source is a `.tsx` generator-function file; project entry is `src/project.ts`.

## Component/explorer notes
Deliverable is deterministic, version-controllable TypeScript: scenes are generator functions (`makeScene2D` + `yield*` animation tweens) composed via `makeProject`. Same source + same inputs => identical MP4, satisfying OOTA determinism. Authoring API is largely shared with Motion Canvas (Node/Rect/Txt/Img/Video/Audio components, signals, tweening). Audio sync via the `Audio` tag; dynamic inputs passed as render variables/params for templating. Primary artifact kind = video (MP4); plays in the default video artifact shell. Unlike Motion Canvas, fully headless render is first-class (`renderVideo()` / `npm run render`) — no web editor needed for delivery, though `npm start` gives a live preview editor for authoring.
