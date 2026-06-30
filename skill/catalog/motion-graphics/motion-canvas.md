# Motion Canvas (motion-graphics)

<!-- generated draft — needs validation -->

- **slug**: `motion-canvas`
- **category**: motion-graphics
- **artifact kind**: video
- **confidence**: medium

## Summary

Motion Canvas is an MIT-licensed TypeScript library + web editor for programmatic vector animation. Animations are authored as deterministic, version-controllable TypeScript (generator-based `scene*` functions) and rendered to an image sequence or, via the official `@motion-canvas/ffmpeg` exporter, directly to MP4 (H.264). It is driven from Node.js/npm and built on Vite.

The primary deliverable is **video**. Animation is fully deterministic: time is driven by `yield*` and tween flow functions (`all`, `sequence`, `waitFor`, `spring`), so identical source produces identical frames — git-friendly and reproducible.

**OOTA caveat (why confidence = medium):** official rendering is triggered from the browser-based editor UI (the RENDER button), and as of 2025/2026 there is **no first-class headless/CLI render command** (open upstream requests: GH issues #415, #1218). Fully headless/CI rendering requires a community workaround — driving the Vite-served editor with a headless browser (Puppeteer/Playwright) to click RENDER or call the render API. So unattended deterministic rendering on macOS is possible but not turnkey. Compared with Remotion (which has a true headless CLI, `npx remotion render`), Motion Canvas is weaker on headless automation but lighter-weight and purpose-built for vector motion graphics.

## Skills

| Resource | Type | Official | URL | License / Attribution |
|---|---|---|---|---|
| motion-canvas (community Claude Code skill) | skill | community | https://github.com/apoorvlathey/motion-canvas-skills | MIT — apoorvlathey. Install: `npx add-skill apoorvlathey/motion-canvas-skills`. Covers TS animation authoring, API reference, common patterns; does NOT cover headless/CLI rendering. |
| Motion Canvas official docs | docs | official | https://motioncanvas.io/docs/ | MIT (project) — motion-canvas.io. Quickstart, rendering, FFmpeg exporter docs. |
| Motion Canvas source + exporters | repo | official | https://github.com/motion-canvas/motion-canvas | MIT. Exporters repo: https://github.com/motion-canvas/exporters ; FFmpeg pkg: https://www.npmjs.com/package/@motion-canvas/ffmpeg |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| TypeScript/JavaScript (Node.js / npm) | Scaffold: `npm create @motion-canvas@latest` — or add to existing: `npm install @motion-canvas/core @motion-canvas/2d`; for video: `npm install --save @motion-canvas/ffmpeg` | `npm start` serves the Vite dev server with the editor at `localhost:9000`; rendering is triggered from the editor UI (Video Settings tab → RENDER), not a CLI. |
| Headless render (community) | `npm install --save-dev puppeteer` (or `playwright`) | Start the Vite editor (`npm start`), then drive it with a headless Chromium script that clicks RENDER / calls the render API. Community-supported; not official. |

Packages: `@motion-canvas/core`, `@motion-canvas/2d`, `@motion-canvas/ui`, `@motion-canvas/ffmpeg`. The Vite plugin `@motion-canvas/vite-plugin` drives dev/preview. `@motion-canvas/ffmpeg` bundles `ffmpeg-static`, so no separate system ffmpeg install is required for the video exporter.

## Artifact kind

**video** — primary deterministic deliverable (MP4 / H.264 via the FFmpeg exporter; the image-sequence exporter writes PNG frames instead).

## Validation

- **install**: `npm create @motion-canvas@latest my-anim -- --template typescript && cd my-anim && npm install && npm install --save @motion-canvas/ffmpeg`
- **smoke**: Add `ffmpeg()` to `plugins` in `vite.config.ts`, then start the editor (`npm start`) and trigger RENDER from the Video Settings tab with the FFmpeg exporter selected. NOTE: there is no headless macOS one-liner — fully unattended rendering needs a headless-browser driver script (Puppeteer/Playwright) pointed at the Vite editor, which is community-supported, not official.
- **expect**: A `project.mp4` (H.264) written to the project's `/output` directory (the image-sequence exporter writes PNG frames to `/output` instead).

## Wrapper params

- `motion-graphics.title` (text) — scene title / label.
- `motion-graphics.duration` (range) — animation duration in seconds.
- `motion-graphics.fps` (select) — frame rate (24/30/60).
- `motion-graphics.bg` (color) — scene background color.
- `motion-graphics.width` / `motion-graphics.height` (range) — output resolution.
- `motion-graphics.source` (textarea, bound to `src/scenes/example.tsx`) — the TypeScript generator scene.

## Component / explorer notes

Author scenes as TypeScript generator functions (`makeScene2D(function* (view) { ... })`) using `@motion-canvas/2d` primitives (`Rect`, `Circle`, `Txt`, `Layout`, `Line`, `Img`, `Video`, `Audio`, `Code`). Animation is deterministic: time advances only through `yield*` and flow helpers (`all`, `sequence`, `waitFor`, `spring`), so identical source = identical frames. Output config (resolution, fps 24/30/60, frame range, color space sRGB/DCI-P3) lives in project meta files. Strong fit for OOTA's deterministic code-as-deliverable model for explainer / data-viz / title-card video.

Biggest OOTA wrapper gap: **no official headless CLI render.** To emit a video file in a headless macOS pipeline the wrapper must (a) start the Vite editor server (`npm start` / `vite`), (b) drive it with headless Chromium (Puppeteer/Playwright) to click RENDER or call the render API, with the `@motion-canvas/ffmpeg` exporter configured in `vite.config.ts`. The FFmpeg exporter ships `ffmpeg-static`, so no system ffmpeg dependency. Track upstream headless-CLI work (GH issues #415, #1218) — if/when an official `render` CLI lands, the wrapper simplifies dramatically and confidence rises to high.
