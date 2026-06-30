# maplibre-gl (maps-geo)

<!-- generated draft — needs validation -->

## Summary

MapLibre GL is the open-source (BSD-licensed) successor to Mapbox GL for
interactive vector/raster maps. Two renderers share the same JSON style spec:

1. **MapLibre GL JS** — a browser library authored as deterministic HTML/JS.
   Natural OOTA deliverable is a self-contained HTML map, headless-renderable
   to PNG via headless Chrome / Puppeteer (await `map.on('idle')`, then
   screenshot).
2. **MapLibre GL Native** — with official Node bindings
   (`@maplibre/maplibre-gl-native`) that rasterize a style directly to a raw
   RGBA buffer (→ PNG via `sharp`) with NO browser, fully headless.

For OOTA the primary deterministic file output is an **image** (static map PNG);
**html** is the alternate kind for interactive maps. The `style.json` + data is
the version-controllable source of truth.

Confidence: **high**.

## Skills

| Name | Type | Official | License | URL |
|---|---|---|---|---|
| MapLibre GL JS official docs + examples | documentation | official | BSD-3-Clause | https://maplibre.org/maplibre-gl-js/docs/ |
| MapLibre Style Spec | documentation | official | BSD-3-Clause | https://maplibre.org/maplibre-style-spec/ |
| awesome-maplibre (curated tools/plugins) | community-repo | official (MapLibre org) | CC0/MIT (list) | https://github.com/maplibre/awesome-maplibre |
| mbgl-renderer (CLI/HTTP/Node static renderer, xvfb for headless) | community-repo | community | ISC | https://github.com/consbio/mbgl-renderer |
| pymgl (Python static renderer over GL Native) | community-repo | community | MIT | https://github.com/brendan-ward/pymgl |

- **MapLibre GL JS docs / Style Spec / awesome-maplibre** — MapLibre
  contributors (official), BSD-3-Clause. Canonical API + declarative JSON style
  reference + curated tool/plugin index.
- **mbgl-renderer** — Conservation Biology Institute / B. Ward (community, ISC).
  CLI + HTTP + Node static renderer; needs `xvfb-run` on Linux headless.
- **pymgl** — Brendan Ward (community, MIT). Thin Python binding over MapLibre
  GL Native: `Map(style).renderPNG()` → PNG bytes.

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/Node (22/24/26) | `npm i @maplibre/maplibre-gl-native sharp` | `new mbgl.Map()` → `map.load(style)` → `map.render({width,height,zoom,center}, cb)` returns raw RGBA buffer → `sharp` → PNG. No browser/X server. (image kind) |
| JS/TS (browser) | `npm i maplibre-gl@5` (or CDN `https://unpkg.com/maplibre-gl@5/dist/maplibre-gl.js` + `.css`) | Author a single HTML file; headless render by loading in Puppeteer/Chrome, `await map.on('idle')`, screenshot to PNG. (html kind) |
| Python (CPython) | `pip install pymgl` (prebuilt wheels macOS/Linux) | `Map(style).renderPNG()` → PNG bytes. Good for report generation. |

Notes:
- `@maplibre/maplibre-gl-native` ships official prebuilt binaries for macOS
  (amd64/arm64), Ubuntu 24.04, Windows. BSD-2-Clause. Fully headless.
- `maplibre-gl` v5.24.0 stable (6.0 in pre-release as of 2026). `html` is the
  version-controlled source kind for interactive maps.
- Avoid `mapbox-gl` (non-free license since v2) — MapLibre is the BSD fork and
  the supported choice.

## Artifact kind

**image** (static map PNG via GL Native). Alternate kind: **html** (interactive
map authored as a self-contained HTML file).

## Validation

- **Install:** `npm init -y && npm i @maplibre/maplibre-gl-native sharp`
- **Smoke (Node):**
  ```bash
  node -e "const mbgl=require('@maplibre/maplibre-gl-native');const sharp=require('sharp');const style={version:8,sources:{},layers:[{id:'bg',type:'background',paint:{'background-color':'#1d6fb8'}}]};const map=new mbgl.Map({ratio:1});map.load(style);map.render({width:256,height:256,zoom:0,center:[0,0]},(err,buf)=>{if(err)throw err;map.release();sharp(buf,{raw:{width:256,height:256,channels:4}}).toFile('map.png',e=>{if(e)throw e;console.log('OK');});});"
  ```
- **Expect:** prints `OK` and writes `map.png` — a 256x256 solid blue PNG.
  Fully headless on macOS (no X server, no network: the style uses only a
  background layer, so the smoke is deterministic and offline). Real maps add a
  vector/raster `source` (e.g. a tiles URL or local mbtiles), which needs
  network/data.

## Wrapper params

- `maps-geo.title` (text) — map label
- `maps-geo.center` (text) — `lon,lat`, e.g. `0,0`
- `maps-geo.zoom` (range) — zoom level
- `maps-geo.width` / `maps-geo.height` (text) — pixel dimensions
- `maps-geo.bg` (color) — background color
- `maps-geo.ratio` (range) — DPI/pixel ratio for the render
- `maps-geo.style` (textarea, bound to `src/style.json`) — MapLibre GL JSON style spec

## Component / explorer notes

Source of truth is the MapLibre Style Spec JSON (version 8): `sources` +
`layers` + paint/layout expressions — fully declarative, diffable,
version-controllable. The same `style.json` drives both GL JS (browser/html)
and GL Native (server/image), so authoring is renderer-agnostic.

Determinism caveat: pixel output depends on the renderer version, fonts/glyphs
(need a `glyphs` URL or local SDF set), sprite/icon assets, and DPI/ratio. Pin
`maplibre-gl` / `@maplibre/maplibre-gl-native` versions and vendor glyph+sprite
assets for reproducible renders. Tile data from remote sources introduces
network nondeterminism — vendor mbtiles/PMTiles locally for reproducibility.

Two clean OOTA paths: (A) **image** via `@maplibre/maplibre-gl-native` —
deterministic, no browser, emits PNG directly; best for static maps, reports,
thumbnails. Wrap as `render(style, {width,height,center,zoom,bearing,pitch,ratio})`
→ `sharp` → file. (B) **html** — ship a self-contained HTML file embedding
`maplibre-gl` (pinned), render headlessly to PNG via Puppeteer after the map
`idle` event. Prefer (A) for batch/static deliverables; use (B) when
interactivity is the deliverable. For raster tile pyramids/MBTiles use community
`mbgl-renderer` or `mapgl-tile-renderer`.
