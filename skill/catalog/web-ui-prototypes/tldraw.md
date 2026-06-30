# tldraw SDK

## Summary
tldraw is a React infinite-canvas SDK (latest SDK 5.x, May 2026; npm `tldraw`). You author drawings/diagrams interactively or as a deterministic `.tldr` JSON document — the tldraw store snapshot (shapes, pages, bindings), which is diffable and version-controllable. For OOTA the deterministic source-of-truth is the `.tldr` file; the primary headless emit is **SVG** (PNG available via a raster stage).

tldraw's own export (`Editor.toImage()` / `getSvgElement()`) requires a DOM/React/browser env, so headless Node rendering goes through the community `@kitschpatrol/tldraw-cli`, which serves a local tldraw instance and drives Puppeteer (headless Chromium) to invoke the SDK's export.

## Skills
| Name | Type | Official | URL | License | Attribution |
|------|------|----------|-----|---------|-------------|
| tldraw llms.txt docs | llms-docs | yes | https://tldraw.dev/llms.txt | docs (tldraw.dev) | tldraw — publishes llms.txt + llms-docs.txt, llms-examples.txt, llms-releases.txt |
| Official Claude Code plugin (planned) | skill-tracking-issue | yes | https://github.com/tldraw/tldraw/issues/8107 | MIT (repo) | tldraw/tldraw issue #8107 — internal `.claude/` skills + CLAUDE.md exist for contributors; public plugin not yet published as of mid-2026 |
| Tldraw SDK Documentation Writer | community-skill | no | https://mcpmarket.com/tools/skills/tldraw-sdk-documentation-writer | unstated | community-listed Claude Code skill on mcpmarket |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JS/TS (React, browser/DOM) | `npm i tldraw` (or `npm create tldraw@latest`) | SDK: React infinite-canvas component + Editor API. Authoring/runtime, not headless. SDK 5.x as of May 2026 |
| JS/TS (Node + Puppeteer / headless Chromium) | `npm i -g @kitschpatrol/tldraw-cli` (or `npx @kitschpatrol/tldraw-cli`) | `tldraw export file.tldr --format svg\|png`. Programmatic: `import { tldrawToImage } from '@kitschpatrol/tldraw-cli'; await tldrawToImage('./sketch.tldr',{format:'svg'})`. MIT, by Eric Mika |

## Artifact kind
**svg** — primary headless deliverable is a self-contained SVG document exported from the `.tldr` snapshot. (PNG raster optional via `--format png`.)

## Validation
- **install:** `npm i -g @kitschpatrol/tldraw-cli`  — needs Node 18+ and a Chromium puppeteer can drive (auto-downloaded)
- **smoke:** `npx @kitschpatrol/tldraw-cli export ./drawing.tldr --format svg -o ./out -n drawing`  — `.tldr` is the deterministic tldraw store snapshot (JSON); for PNG use `--format png`
- **expect:** writes `./out/drawing.svg` (a self-contained SVG document) and exits 0; export takes ~1-2s as it spins a headless browser. PNG variant writes `drawing.png`.

## Wrapper params
- `web-ui-prototypes.title` (text) — drawing title / label text
- `web-ui-prototypes.format` (select: svg, png) — headless emit format
- `web-ui-prototypes.tldr` (textarea, file-bound to `src/drawing.tldr`) — the deterministic store snapshot

## Component / explorer notes
- Deterministic source is the `.tldr` document — a JSON serialization of the tldraw store (shapes, pages, bindings). Diffable / version-controllable.
- tldraw.com share URLs can also be passed to the CLI.
- SDK 5.x is current (May 2026); minor bumps roughly monthly.
- Custom shapes need a `toSvg` method to export correctly.
- Headless rendering is NOT pure Node — tldraw export fundamentally depends on a browser DOM. The CLI wraps this by serving a local tldraw + driving Puppeteer; account for headless Chromium availability on macOS (puppeteer downloads its own). SVG is the cleanest deterministic emit; PNG adds a raster stage. The official SDK `Editor.toImage()` is unsuitable for OOTA's headless pipeline without the same browser dependency. No official Claude skill yet — rely on tldraw.dev/llms.txt for SDK context.
