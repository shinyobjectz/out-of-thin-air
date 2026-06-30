# leaflet (maps-geo)

## Summary
Leaflet is the leading open-source JavaScript library (~42KB) for mobile-friendly interactive maps. Latest is 2.0.0-alpha.1 (Aug 2025), a modernization shipping ESM, Pointer Events, dropping IE/legacy polyfills; the stable line remains 1.9.x. For OOTA the deterministic, version-controllable deliverable is a self-contained HTML document that initializes a Leaflet map (tile layer + markers/polygons/GeoJSON) in the browser. The most reproducible authoring path is Python's folium, which compiles a Leaflet map to one portable `.html` file via `map.save()` — no browser/server needed (pure string templating = deterministic, diff-able output). A raster IMAGE (PNG) deliverable is also achievable headlessly via Puppeteer/leaflet-headless, but it depends on live tile fetches (non-deterministic), so HTML is the primary kind.

## Skills
- [anthropics/skills](https://github.com/anthropics/skills) — reference, official, license: see repo. Official Agent Skills repo; no Leaflet-specific skill exists, use as the SKILL.md authoring reference.
- [Leaflet official docs/tutorials](https://leafletjs.com/reference.html) — docs, official, license: BSD-2-Clause (library). Canonical API reference + quick-start tutorials.
- [python-visualization/folium](https://github.com/python-visualization/folium) — community library docs, license: MIT. Python wrapper that emits self-contained Leaflet HTML; strongest deterministic authoring path.
- [leafmap](https://leafmap.org/) — community library docs, license: MIT. Qiusheng Wu — multi-backend (folium/ipyleaflet) mapping toolkit with export helpers.

## Toolchains
| lang | install | invoke / notes |
|------|---------|----------------|
| Python (CPython 3.9+) | `pip install folium` | Primary deterministic path. `m=folium.Map(...); m.save('out.html')` writes one portable Leaflet HTML file via Jinja2 templating — no browser/network at author time. |
| JavaScript/HTML (browser, no build) | `<link>/<script>` from `https://unpkg.com/leaflet@1.9.4/dist/` (pin version + SRI) | Hand-author a static `.html` that loads Leaflet from a pinned CDN and instantiates the map inline. Fully version-controllable markup. |
| JavaScript (Node 18+) | `npm install leaflet` | v2.0 is ESM: `import {Map, TileLayer, Marker} from 'leaflet'`. v1.9.x uses global `L`. For bundling into custom HTML/JS pipelines. |
| JavaScript (Node 18+ headless Chrome) | `npm install puppeteer` | Optional IMAGE path: load the Leaflet HTML in headless Chrome and `page.screenshot({path:'map.png'})`. Requires live tiles, so output is non-deterministic unless tiles are stubbed/cached. |

## Artifact kind
`html` — a self-contained interactive Leaflet map document.

## Validation
- install: `python3 -m venv /tmp/lf && /tmp/lf/bin/pip install folium`
- smoke: `/tmp/lf/bin/python -c "import folium; m=folium.Map(location=[37.7749,-122.4194], zoom_start=12); folium.Marker([37.7749,-122.4194], popup='SF').add_to(m); m.save('/tmp/map.html')"`
- expect: Exit 0; `/tmp/map.html` exists (single self-contained file, tens of KB) containing `leaflet` CDN refs and an `L.map(...)` init. Fully headless on macOS, no browser needed. Open in any browser to see an interactive SF map with a marker. Generation is deterministic (same input → byte-identical HTML modulo a random map div id).

## Wrapper params
- `maps-geo.title` (text) — page/title.
- `maps-geo.lat` / `maps-geo.lng` (text) — map center.
- `maps-geo.zoom` (range) — initial zoom level.
- `maps-geo.marker_popup` (text) — marker popup label.

## Component / explorer notes
Primary deliverable is one self-contained `.html`: a `div` + pinned Leaflet CSS/JS (CDN or inlined) + an init script setting view, tile layer (e.g. OpenStreetMap), and overlays (markers, polylines, polygons, GeoJSON). Keep all data inline (GeoJSON literals) so the artifact is self-contained and diff-able. Tile imagery is fetched at view time from a tile server — the HTML is deterministic but the rendered pixels depend on the live tile source; pin tile attribution and URL template. folium injects a random map element id per save; set it explicitly if byte-stable output is required.

Recommend folium as the OOTA wrapper: pure-Python, no headless browser, emits one portable HTML file deterministically, easy to parametrize from data. For a no-Python path, template a static Leaflet HTML against a version-pinned unpkg CDN (leaflet@1.9.4) with SRI hashes. If a PNG artifact is required, add a Puppeteer post-step (load HTML, wait for tiles, screenshot) — flag it as non-deterministic due to remote tiles; mitigate by pointing at a local/cached tile set. Pin to 1.9.x for stability; 2.0 is still alpha and ESM-only.
