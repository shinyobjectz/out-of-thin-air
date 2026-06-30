# maps-geo

Maps as a version-controlled source (JSON GL style / GeoJSON / Python map code) compiled into a deliverable: a static `image` (PNG) or a self-contained interactive `html` file. Headless, offline-leaning where possible.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [MapLibre GL](./maplibre-gl.md) | image | JS/Node (maplibre-gl-native + sharp); JS/TS browser (maplibre-gl@5); Python (pymgl) | MapLibre GL JS official docs + examples | yes | ok | yes | yes |
| [mapbox-gl](./mapbox-gl.md) | image | mbgl-renderer (Node); maplibre-gl-native (Node); pymgl (Python); mapbox-gl (browser, not headless) | Mapbox Agent Skills | yes | ok | yes | yes |
| [deck.gl](./deck-gl.md) | image | JS/TS (Node + headless Chromium/Puppeteer); Python (pydeck); React/JSX (@deck.gl/react) | none (no official Anthropic skill) | no | ok | yes | yes |
| [kepler.gl](./kepler-gl.md) | html | Python (keplergl save_to_html) PRIMARY; JS/TS (kepler.gl, not headless) | keplergl-jupyter user guide | yes | ok | yes | yes |
| [leaflet](./leaflet.md) | html | Python/folium; JS/HTML (CDN); JS/Node leaflet; JS/Node puppeteer | python-visualization/folium | no | ok | yes | yes |
| [folium](./folium.md) | html | Python (CPython >=3.9, folium) | Folium official docs | yes | ok | yes | yes |
| [osmnx](./osmnx.md) | image | Python | OSMnx official docs (ReadTheDocs) | yes | ok | yes | yes |
| [prettymapp](./prettymapp.md) | image | Python (CPython 3.9+) | prettymapp | no | ok | yes | yes |

## Multi-toolchain notes

- **GL-style renderers share one source.** MapLibre GL and mapbox-gl both consume Style Spec JSON v8. The headless path for both is MapLibre GL Native static render (`maplibre-gl-native` / `mbgl-renderer` / `pymgl`) — NOT browser `mapbox-gl-js`. Embed GeoJSON in the style to stay token-free and offline; remote raster/vector tiles need a `MAPBOX_ACCESS_TOKEN`.
- **deck.gl has no headless library renderer.** Node WebGL1 support was dropped; PNG capture requires a real browser (headless Chromium/Puppeteer) with `--use-gl=swiftshader` to avoid an empty canvas. Determinism contract: `controller:false`, bundled static data, no basemap tiles, screenshot after `onAfterRender`. `pydeck.to_html` is the secondary html path.
- **Python html generators are the reliable headless authoring path.** folium (`m.save()`), leaflet-via-folium, and kepler.gl (`save_to_html`) all emit a self-contained interactive file with no browser launch. Output is deterministic modulo a random map div id (folium/leaflet). Basemap tiles fetch at view time, not build time. kepler.gl PNG export is out of scope (browser-only, GH issue #974).
- **OSM-data tools need network at fetch time.** osmnx and prettymapp pull from the OSM Overpass / Nominatim APIs, so output is non-deterministic unless geometries are cached; the render step itself is headless (`MPLBACKEND=Agg`). Neither ships a CLI — the step script emits a thin Python entrypoint and graceful-degrades.

## Validation order

Cheapest / most reliable installs first; defer network- and browser-dependent ones:

1. **folium** — single `pip install folium`, fully headless/offline, deterministic. Best smoke baseline.
2. **leaflet** (folium-backed) — same pip-only path; also emits a pinned-CDN HTML fallback.
3. **kepler.gl** — `pip install keplergl pandas`, headless `save_to_html`, offline at build time.
4. **MapLibre GL** — `npm i @maplibre/maplibre-gl-native sharp`; headless + offline with embedded style, but depends on a prebuilt native binary matrix.
5. **mapbox-gl** (mbgl-renderer) — Node native render; verify macOS no-xvfb behavior + prebuilt-binary matrix (confidence medium).
6. **deck.gl** — heaviest install (`puppeteer` + Chromium download); needs swiftshader GL. Run after the lighter paths pass.
7. **osmnx** — requires live Overpass/Nominatim network at fetch time.
8. **prettymapp** — same network dependency as osmnx; non-deterministic without geometry cache. Validate last.

## Explorer needs

Most tools run in the default shell. Richer explorers wanted by:

- **deck.gl** — needs a headless-browser explorer (Chromium/Puppeteer with WebGL/swiftshader); the default shell cannot capture the WebGL canvas.
- **MapLibre GL / mapbox-gl** — need a native-binary-capable runtime (node-pre-gyp prebuilds for maplibre-gl-native); confirm the platform binary matrix before relying on the shell default.
- **osmnx / prettymapp** — need network egress to OSM Overpass + Nominatim at build time; an explorer with caching would make output deterministic.

## Tool dossiers

- [maplibre-gl.md](./maplibre-gl.md)
- [mapbox-gl.md](./mapbox-gl.md)
- [deck-gl.md](./deck-gl.md)
- [kepler-gl.md](./kepler-gl.md)
- [leaflet.md](./leaflet.md)
- [folium.md](./folium.md)
- [osmnx.md](./osmnx.md)
- [prettymapp.md](./prettymapp.md)
