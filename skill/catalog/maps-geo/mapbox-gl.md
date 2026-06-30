# mapbox-gl (maps-geo)

<!-- generated draft — needs validation -->

## Summary

Mapbox GL renders vector/raster maps from a declarative JSON style spec. The
interactive product (`mapbox-gl-js`) is browser-only and not headless or
deterministic. For OOTA the deterministic path is **server-side static
rendering** of a Mapbox GL style to a PNG via **MapLibre GL Native** (the
open-source fork of Mapbox GL Native; Mapbox's own native node bindings are
unmaintained).

The OOTA deliverable is a version-controllable JSON **style + viewport spec**
that renders headlessly to a raster image (PNG). Mapbox-hosted tiles/styles
require a `MAPBOX_ACCESS_TOKEN`; fully offline rendering works with
self-hosted / MapLibre styles + embedded GeoJSON.

Confidence: **medium** — verify macOS no-xvfb behavior and the exact
prebuilt-binary Node matrix on the target machine before committing a pipeline.

## Skills

| Name | Type | Official | License | URL |
|---|---|---|---|---|
| Mapbox Agent Skills | skill-collection | official | see repo (Mapbox official) | https://github.com/mapbox/mapbox-agent-skills |
| Mapbox MCP Server | mcp | official | Mapbox official | https://www.mapbox.com/blog/introducing-the-mapbox-model-context-protocol-mcp-server |
| mapbox-use-guide | skill | community | unspecified | https://skillsmp.com/skills/hnkatze-bipbipbackoffice2-1-claude-skills-mapbox-use-guide-skill-md |

- **Mapbox Agent Skills** — Mapbox, Inc. (official). Docs:
  https://docs.mapbox.com/api/guides/mapbox-agent-skills/ . Install via
  `npx skills add mapbox` (Claude Code, Cursor, Copilot). 15+ skills covering
  web/iOS/Android integration, map design, search, geospatial ops, migrations,
  perf. Focus is app-building guidance, NOT headless rendering.
- **Mapbox MCP Server** — Mapbox, Inc. (official). Structured LLM access to the
  Mapbox location platform (geocoding, directions, etc.).
- **mapbox-use-guide** — community author hnkatze; quality unverified.

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/Node (18/20/22) | `npm add mbgl-renderer` | CLI `mbgl-render style.json out.png 512 256 -c -79.86,32.68 -z 10`; API `import render from 'mbgl-renderer'; render(style,512,256,{zoom,center}).then(d=>fs.writeFileSync('out.png',d))` |
| JavaScript/Node (20+/24) | `npm add @maplibre/maplibre-gl-native` | Lower-level official MapLibre Native binding; render GL styles to image buffers directly |
| Python (CPython 3.x) | `pip install pymgl` | MapLibre GL Native static renderer; GL style -> PNG bytes. Repo: https://github.com/brendan-ward/pymgl |
| JavaScript (browser) | `npm add mapbox-gl` | Interactive client lib — NOT deterministic/headless. Avoid for OOTA |

Notes:
- `mbgl-renderer` (MIT, v0.9.0 May 2025) wraps `@maplibre/maplibre-gl-native`.
  On Linux headless servers needs **xvfb** (`xvfb-run`); on macOS works without
  an X server. Mapbox-hosted styles/tiles need `MAPBOX_ACCESS_TOKEN`.
- Prebuilt binaries gate supported Node versions for the native binding.
- `mapbox-gl-js` (browser) tile-load races make it unreliable headlessly; only
  use if driving via Puppeteer/Chrome. Prefer the native static renderers.

## Artifact kind

**image** (PNG raster output from the static renderer).

## Validation

- **Install:** `npm add mbgl-renderer`
- **Smoke (Node ESM):**
  ```js
  import render from 'mbgl-renderer';
  import fs from 'fs';
  const style = JSON.parse(fs.readFileSync('node_modules/mbgl-renderer/tests/fixtures/example-style.json'));
  render(style, 512, 256, { zoom: 10, center: [-79.86, 32.68] })
    .then(d => fs.writeFileSync('test.png', d));
  ```
  or CLI:
  ```bash
  npx mbgl-render node_modules/mbgl-renderer/tests/fixtures/example-style.json test.png 512 256 -c -79.86,32.68 -z 10
  ```
- **Expect:** a 512x256 PNG `test.png` (non-zero bytes, valid PNG header). macOS
  needs no xvfb. If the fixture style references remote tiles, set
  `MAPBOX_ACCESS_TOKEN` or use a self-contained MapLibre style for offline output.

## Wrapper params

- `maps-geo.title` (text) — map label
- `maps-geo.center` (text) — `lon,lat`, e.g. `-79.86,32.68`
- `maps-geo.zoom` (range) — zoom level
- `maps-geo.width` / `maps-geo.height` (text) — pixel dimensions
- `maps-geo.style` (textarea, bound to `src/style.json`) — Mapbox/MapLibre GL JSON style

## Component / explorer notes

OOTA component = a Mapbox/MapLibre GL JSON **style spec** plus a **viewport spec**
(center+zoom OR bounds, width, height, ratio/DPI, optional GeoJSON overlays).
Both are plain JSON — deterministic and diff-friendly. The style references
sources (vector/raster tiles, GeoJSON), layers, paint/layout props. Pin tile
sources to specific tilesets/versions for reproducibility; embedded GeoJSON
sources give a fully self-contained, offline-renderable component.

Wrapper invokes `mbgl-renderer` (Node) or `pymgl` (Python) as a headless render
step: input = `style.json` + viewport opts, output = PNG. Handle
`MAPBOX_ACCESS_TOKEN` as an env secret only for Mapbox-hosted tiles; default to
self-hosted/MapLibre styles for token-free deterministic builds. On Linux CI
wrap with `xvfb-run`; macOS runs natively. `mapbox-gl-js` (browser) is explicitly
NOT the headless path — the wrapper must not depend on a browser.
