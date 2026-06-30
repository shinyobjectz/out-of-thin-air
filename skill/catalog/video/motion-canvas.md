<!-- generated draft — needs validation -->
# motion-canvas (video)

## Summary
Motion Canvas is a TypeScript/JS library plus a Vite-based browser editor for procedural, frame-accurate motion graphics. Scenes are authored as generator functions (a `yield`-driven timeline) in `.tsx` files; you preview and render in a browser editor at `http://localhost:9000`, and export an image sequence or video (`.mp4` via the `@motion-canvas/ffmpeg` exporter). Primary deliverable is **video**. It is JS/TS-only — no Python/Go/Rust/native bindings; all driving happens through the Node toolchain. Rendering is browser-driven by default; true headless/CI rendering is not first-class (open issues #415, #1218) and relies on community Puppeteer workarounds.

## Skills
| Skill | Type | Official | URL | License |
|-------|------|----------|-----|---------|
| motion-canvas (apoorvlathey/motion-canvas-skills) | community | no | https://skills.sh/apoorvlathey/motion-canvas-skills/motion-canvas | unspecified — check repo github.com/apoorvlathey/motion-canvas-skills |
| Official Motion Canvas docs | official-docs | yes | https://motioncanvas.io/docs/ | MIT (docs in motion-canvas/motion-canvas repo) |

Attribution: community skill by apoorvlathey; official docs by the Motion Canvas project.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node >=16 + Vite) | `npm init @motion-canvas@latest my-mc -- --template typescript && cd my-mc && npm install && npm install --save @motion-canvas/ffmpeg` | `npm run serve` (editor at http://localhost:9000; click RENDER) |

Packages: `@motion-canvas/core`, `@motion-canvas/2d`, `@motion-canvas/ui`, `@motion-canvas/vite-plugin`, `@motion-canvas/ffmpeg`. Only supported toolchain. `npm init @motion-canvas@latest` scaffolds a Vite project; `npm run serve` launches the editor for preview/render. Add video export with `npm install --save @motion-canvas/ffmpeg`.

## Artifact kind
**video** — primary output is a standard `.mp4` (ffmpeg exporter) or a PNG image sequence (default exporter), written to the project `./output` directory.

## Validation
- **install**: `npm init @motion-canvas@latest my-mc -- --template typescript && cd my-mc && npm install && npm install --save @motion-canvas/ffmpeg`
- **smoke**: `npm run serve`  # opens editor at http://localhost:9000; click RENDER to write frames/video to ./output
- **expect**: Editor serves on localhost:9000 with a playable example scene; rendering writes an image sequence (or `.mp4` via the ffmpeg exporter) into `./output`. Note: render is triggered through the browser UI — no clean `motion-canvas render` headless CLI as of mid-2026, so fully headless/macOS-CI rendering needs a Puppeteer driver (community-only).

## Wrapper params
- resolution/scale
- frame rate (24/30/60)
- frame range (partial renders)
- exporter choice (image-sequence vs `@motion-canvas/ffmpeg` mp4)
- audio offset (seconds)
- color space (sRGB/DCI-P3)

Scene source is a `.tsx` generator-function file; project entry is `project.ts`.

## Component/explorer notes
Primary output is a standard `.mp4` (ffmpeg exporter) or PNG image sequence — plays in the default video artifact shell. The authoring experience itself wants the richer browser editor (timeline scrubber, frame stepping at localhost:9000), but the delivered artifact is a plain video file.
