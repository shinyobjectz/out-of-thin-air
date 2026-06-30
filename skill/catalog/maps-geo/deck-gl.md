<!-- generated draft — needs validation -->
# deck.gl (maps-geo)

## Summary
deck.gl is vis.gl's WebGL2/WebGPU GPU-accelerated framework for large-scale data
visualization, primarily geospatial map overlays (scatterplot, arc, hexagon,
GeoJSON, heatmap, 3D tiles). It is browser-rendered on top of luma.gl. For OOTA's
deterministic headless model, deck.gl code is authored as JS that constructs a
`Deck` instance with explicit `initialViewState` + `layers`, rendered in headless
Chromium (Puppeteer/Playwright), then the WebGL canvas is captured to a PNG.
Output is deterministic only if data is bundled/static, animations are disabled,
and you await the redraw / `onAfterRender` before capture. There is NO official
Anthropic/Claude skill and no first-party headless Node renderer — Node WebGL1
support was dropped, so headless = a real browser (swiftshader on CPU where no GPU).

Primary deliverable kind: **image** (static map PNG). Can also ship as standalone
**html** for an interactive map (via pydeck `to_html`).

## Skills
| Name | Type | Official | URL | License |
|---|---|---|---|---|
| No official Anthropic/Claude skill | none | no | https://github.com/anthropics/skills | n/a |
| deck.gl official docs (LLM-ingestable) | docs | yes | https://deck.gl/docs | MIT (docs CC) |
| deck.gl API reference — Deck class | docs | yes | https://deck.gl/docs/api-reference/core/deck | MIT |
| SnapshotTestRunner (headless render+capture reference) | docs | yes | https://deck.gl/docs/api-reference/test-utils/snapshot-test-runner | MIT |
| Capture canvas as image (official codepen) | example | yes | https://codepen.io/Pessimistress/pen/ExyyzjV | MIT |

Attribution: vis.gl / OpenJS Foundation; codepen by Xiaoji Chen (deck.gl maintainer).

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| JavaScript/TypeScript (canonical) | `npm install @deck.gl/core @deck.gl/layers puppeteer` | Author HTML+JS that does `new Deck({canvas, initialViewState, controller:false, layers})`; load in Puppeteer headless, await `onAfterRender`, `page.screenshot()` |
| Python | `pip install pydeck` | `deck.to_html('out.html')` → self-contained interactive HTML; pipe through headless Chromium + screenshot for a PNG |
| React/JSX | `npm install @deck.gl/react @deck.gl/core @deck.gl/layers` | `<DeckGL>` component; same headless-capture story (optional, not needed for static image) |

No native Node-GL path — headless requires a real browser/GPU or swiftshader.

## Artifact kind
**image** — static map PNG. (Secondary: html for interactive maps.)

## Validation
- **install:** `npm install @deck.gl/core @deck.gl/layers puppeteer`
- **smoke:** Create `index.html` that loads deck.gl and instantiates
  `new Deck({canvas:'c', initialViewState:{longitude:-122.45,latitude:37.78,zoom:11}, controller:false, layers:[new ScatterplotLayer({data:[{position:[-122.45,37.78]}], getPosition:d=>d.position, getRadius:1000, getFillColor:[255,0,0]})], onAfterRender:()=>{window.__done=true}})`.
  Drive with a Node Puppeteer script: launch headless Chromium with
  `--use-gl=swiftshader`, `page.goto file://index.html`,
  `await page.waitForFunction('window.__done')`, then
  `await page.screenshot({path:'map.png'})`.
- **expect:** `map.png` written (~800x600 PNG) showing a red dot over San Francisco
  on a dark/transparent background; non-zero file size, byte-stable across runs
  when data + viewState are fixed and no basemap tiles are fetched.

## Wrapper params
- `maps-geo.title` — overlay/map title
- `maps-geo.layer_spec` — JS layer-spec source (bind to `src/layers.js`)
- `maps-geo.longitude`, `maps-geo.latitude`, `maps-geo.zoom` — initial view state
- `maps-geo.width`, `maps-geo.height` — canvas resolution

## Component / explorer notes
deck.gl is fundamentally a GPU/WebGL2 browser library, not a headless CLI. The
deterministic-render contract for OOTA: (1) `controller:false` to freeze the view,
(2) static/bundled data — no live tile or API fetches mid-render, (3) disable any
layer transitions/animations, (4) capture only after `onAfterRender` fires. A
basemap (Mapbox/MapLibre/CARTO tiles) introduces network nondeterminism and auth
tokens — prefer no basemap or a pre-bundled static tile set. WebGPU backend is
emerging but WebGL2 via luma.gl is the stable headless path. macOS headless has no
real GPU in CI — default to `--use-gl=swiftshader` to avoid an empty/black canvas
(known Puppeteer+WebGL pitfall). Pin deck.gl, puppeteer, and the Chromium revision
for byte-stability.
