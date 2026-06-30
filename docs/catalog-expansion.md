# Code-as-Anything — Catalog Expansion Plan

## What this expands

This consolidates 16 per-domain proposals into one ranked plan for growing the
code-as-X catalog. Each candidate authors a deliverable **as code or markup**
(not a GUI session, not a stochastic prompt) and renders it **headlessly in CI**.

**The code-as-X bar — a candidate qualifies only if all three hold:**

1. **Deterministic** — same source in, same artifact out (no LLM/diffusion in the render path, fixed seeds where roughness is involved).
2. **Version-controllable** — the source is diffable text (script, markup, JSON/YAML spec). GUI-authored binaries (`.riv`, `.excalidraw`-via-editor, Canva) fail this.
3. **Renders to one of the 8 kinds** — `html`, `image`, `svg`, `pdf`, `video`, `model3d`, plus the existing artifact kinds the catalog already emits.

Excluded across the board: Canva / Piktochart / Adobe Animate / 8th Wall / Penpot (GUI-first), AI poster/comic/texture generators (stochastic), Rive `.riv` (GUI-authored binary).

---

## NEW CATEGORIES

| proposed id | summary | candidate tools | best skill source |
|---|---|---|---|
| `motion-graphics` | Code-authored timeline animation + declarative motion markup → video/svg/html | Motion Canvas, Lottie (puppeteer-lottie-cli), SVG SMIL, GSAP, anime.js, Theatre.js | official-docs (https://motioncanvas.io/docs/rendering/) |
| `graphic-design` | Imperative/declarative 2D vector design → svg/pdf/png (print deliverables, not sketches) | Satori, DrawBot, SVG.js, Cairo (pycairo/cairosvg), Paper.js, Nannou | official-docs (https://github.com/vercel/satori) |
| `data-visualization` | Charts/plots authored as code/spec, headless → svg/png/pdf | Vega-Lite (vl-convert), Observable Plot, Matplotlib, ggplot2, gnuplot, Plotly (Kaleido), ECharts | official-docs (https://vega.github.io/vega-lite/docs/) |
| `maps-geo` | Maps authored as JSON style + code → html / image | MapLibre GL, Mapbox GL, deck.gl, kepler.gl, Leaflet, Folium, OSMnx, prettymapp | official-docs (https://maplibre.org/maplibre-gl-js/docs/) |
| `3d-shaders` | Declarative/scripted 3D scenes + pure shader source → image/video/model3d | Blender (bpy), OpenUSD (usdrecord), glslViewer, Shadertoy GLSL, A-Frame, POV-Ray | official-docs (https://docs.blender.org/api/current/info_tips_and_tricks.html) |
| `web-ui-prototypes` | UI/components/prototypes authored as code, headless-screenshotted → image/svg/pdf | tldraw SDK, Satori, Storybook + Playwright test-runner, Playwright, frontend-design (Tailwind/shadcn) | anthropic-skill (frontend-design:frontend-design) + official-docs |
| `image-processing` | Batch raster transform/synthesis pipelines as code/DSL → image | ImageMagick (MSL), G'MIC, sharp, Pillow, libvips, GEGL | official-docs (https://imagemagick.org/script/command-line-processing.php) |
| `infographics-posters` | Data-driven infographics + generative print/poster layout → svg/pdf/png | Vega-Lite, DrawBot, drawsvg, Typst, Observable Plot, p5.riso | official-docs (https://vega.github.io/vega-lite/docs/) |
| `social-formats` | Fixed-spec social creative (OG/carousel/story) → image/svg | Satori, @vercel/og, Playwright HTML-to-image, open-carrusel, resvg-js | official-docs (https://github.com/vercel/satori) |
| `ar-vr` | Declarative WebXR scenes + glTF⇄USDZ asset pipelines → html/model3d | A-Frame, `<model-viewer>`, usd_from_gltf / usdcat, Needle, PlayCanvas, Babylon.js | official-docs (https://aframe.io/docs/) |
| `business-documents` | Invoices/resumes/labels/codes as markup+data → pdf/svg/image | Typst invoice-maker, RML (ReportLab), RenderCV, JSON Resume, Segno, python-barcode, ZPL (Labelary), WeasyPrint | official-docs (https://typst.app/universe/package/invoice-maker/) |
| `advertising-creative` | Marketing/ad creative as code → image/html (email + OG + banners) | MJML, react-email, Maizzle, Satori/@vercel/og, AMPHTML ads, HTMLCSStoImage | official-docs (https://documentation.mjml.io/) |
| `comics-illustration` | Sequential art / illustration as code → svg/png | comicgen, Rough.js (+ chart.xkcd, roughViz under diagrams), CSS Grid + balloon.css | repo (https://github.com/gramener/comicgen) |

> `game-engines` was proposed but is **folded into existing `games`** (see Additions) — a dedicated split is optional and only warranted if the catalog wants real engines separated from fantasy-console minigames.

---

## ADDITIONS to existing categories

| existing category | new tools to add | skill source |
|---|---|---|
| `games` (pico8/tic80/love2d) | Godot (GDScript) — html, raylib — image, Pyxel — video, Phaser — html, kaplay — html, Bevy — image, Defold — html, Arcade — image | official-docs: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html ; https://github.com/raysan5/raylib ; https://github.com/kitao/pyxel ; https://docs.phaser.io/phaser/getting-started ; https://kaplayjs.com/guides/install/ ; https://bevyengine.org/learn/quick-start/ ; https://defold.com/manuals/bundling/ ; https://api.arcade.academy/en/latest/ |
| `video` | Revideo (headless Motion Canvas fork) — video; Remotion vertical/story templates — video | official-docs: https://docs.re.video/ ; https://www.remotion.dev/templates/ |
| `creative` (p5/three/processing/openframeworks) | Paper.js — svg, Nannou — image, three.js headless — image, Babylon.js NullEngine — image, p5.riso — image, Theatre.js — html, anime.js — html, Needle — html, PlayCanvas — html, drawsvg — svg | official-docs/community: http://paperjs.org/reference/ ; https://guide.nannou.cc/ ; https://github.com/Dylan-Kentish/headless-threejs ; https://doc.babylonjs.com/features/featuresDeepDive/scene/serverSide ; https://antiboredom.github.io/p5.riso/ ; https://www.theatrejs.com/docs/latest ; https://animejs.com/documentation/ ; https://engine.needle.tools/docs/three/ ; https://developer.playcanvas.com/ ; https://github.com/cduck/drawsvg |
| `documents` | Typst (incl. invoice-maker, cetz-plot charts) — pdf, RML/ReportLab — pdf, WeasyPrint — pdf, basil.js (InDesign) — pdf | official-docs: https://typst.app/docs/ ; https://typst.app/universe/package/cetz-plot/ ; https://docs.reportlab.com/rml/userguide/Chapter_1_Introduction/ ; https://doc.courtbouillon.org/weasyprint/stable/ ; https://basiljs.basislab.org/ |
| `diagrams` | Excalidraw programmatic (@excalidraw/utils) — svg, chart.xkcd — svg, roughViz — svg | official-docs/repo: https://docs.excalidraw.com/docs/@excalidraw/excalidraw/api/utils/export ; https://github.com/timqian/chart.xkcd ; https://github.com/jwilber/roughViz |

---

## TIER-1 — highest-value, cleanest to build first

These are the most deterministic, best-documented, zero-browser-or-single-CLI renders. Build these first.

| tool | category | kind | skill | why |
|---|---|---|---|---|
| Vega-Lite (+ vl-convert) | data-visualization | svg | https://vega.github.io/vega-lite/docs/ | Artifact IS a JSON spec; vl-convert (Rust) renders svg/png/pdf with no browser/node — canonical oota chart. |
| Satori / @vercel/og | graphic-design + social-formats + advertising-creative | svg/image | https://github.com/vercel/satori | Stateless JSX+CSS → deterministic SVG, no browser; anchors three proposed categories at once. |
| MJML | advertising-creative | html | https://documentation.mjml.io/ | Industry-standard declarative markup → client-safe HTML, pure CLI, no GUI; strongest net-new cluster (email). |
| Matplotlib | data-visualization | image | https://matplotlib.org/stable/ | Plain Python + Agg backend → file, ubiquitous, fully CI-friendly. |
| gnuplot | data-visualization | svg | http://www.gnuplot.info/documentation.html | Plain-text `.gp` script piped to one binary → vector/raster; the original oota plot. |
| Godot (GDScript) | games (add) | html | https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html | Text scenes + GDScript, `--headless --export-release` to self-contained HTML5/WASM. |
| ImageMagick | image-processing | image | https://imagemagick.org/script/command-line-processing.php | Whole pipeline is a command string or MSL script; unmatched breadth, deterministic. |
| Blender (bpy) | 3d-shaders | image | https://docs.blender.org/api/current/info_tips_and_tricks.html | Entire scene+render as version-controllable Python; `blender -b -P` deterministic frames. |
| Motion Canvas | motion-graphics | video | https://motioncanvas.io/docs/rendering/ | Animations as diffable TS generators/tweens → frame-exact MP4/WebM; pure oota video. |
| Lottie (puppeteer-lottie-cli) | motion-graphics | video | https://github.com/transitive-bullshit/puppeteer-lottie-cli | Animation IS diffable JSON; renders deterministically headless to video. |
| Typst (invoice-maker) | business-documents | pdf | https://typst.app/universe/package/invoice-maker/ | YAML/JSON data + `.typ` markup → byte-stable PDF via one CLI; also anchors infographics-posters. |
| Segno / python-qrcode | business-documents | svg | https://segno.readthedocs.io/en/stable/comparison-qrcode-libs.html | Payload+params as code → deterministic vector; trivially embeddable/CI. |
| prettymapp / OSMnx | maps-geo | image | https://github.com/chrieke/prettymapp | Pure-Python deterministic map render to image/svg/pdf, no browser — cleanest maps fit. |
| Playwright (screenshot/pdf) | web-ui-prototypes + social-formats | image | https://playwright.dev/docs/screenshots | Generic headless renderer that turns any repo HTML/Tailwind into reproducible image/pdf in CI. |
| comicgen | comics-illustration | svg | https://github.com/gramener/comicgen | Only tool purpose-built for comics-as-code; params → deterministic SVG. |
| A-Frame | ar-vr | html | https://aframe.io/docs/ | Immersive 3D/VR scene is pure declarative HTML markup — most version-control-friendly 3D form. |

---

## Dedup / overlap notes vs existing catalog

- **`creative` (p5/three/processing/openframeworks)** already covers interactive canvas/GL sketches. Keep the new categories distinct by output intent:
  - `graphic-design` = print/vector **deliverables** (svg/pdf), not live sketches. Paper.js/Nannou straddle the line → filed as add-to:creative.
  - `image-processing` = batch **raster transform** pipelines, not canvas sketches.
  - `3d-shaders` overlaps creative for three.js/Babylon — those route to `creative` (add); the **novel** parts are declarative markup (A-Frame, model-viewer) and asset pipelines (USD, bpy, POV-Ray, glslViewer).
- **`video`** already holds Remotion. Revideo and Remotion templates are **add-to:video**, not new. Motion Canvas is distinct enough (code-authored scene graph, not React/Remotion) to anchor `motion-graphics`; Lottie/SMIL/GSAP are genuinely new motion paradigms.
- **`documents`** already exists. Typst/RML/WeasyPrint/basil.js are document **engines** → add-to:documents. Only the QR/barcode/label-language/resume entries justify the separate `business-documents` id.
- **`diagrams`** already exists. Excalidraw-programmatic, chart.xkcd, roughViz are sketchy-vector → add-to:diagrams (not comics). `comics-illustration` is anchored only by the comics-purpose-built comicgen + Rough.js.
- **Satori appears in 3 proposed categories** (graphic-design, social-formats, advertising-creative, web-ui-prototypes). Build it once as a shared renderer; categorize the *outputs* (OG card vs UI snapshot vs design asset), not the tool.
- **Vega-Lite / Observable Plot appear in both `data-visualization` and `infographics-posters`.** Treat data-viz as the home; infographics-posters reuses them and adds the print/poster engines (DrawBot, drawsvg, p5.riso, Typst).
- **`games` vs `game-engines`:** fold engines into `games`; only split if fantasy-console minigames need separation from full engines.
- **Token/non-determinism edges:** Mapbox GL needs an access token (MapLibre is the token-free default); Rive `.riv` is GUI binary (excluded); basil.js needs an InDesign host (not fully headless, low confidence); AMPHTML ads / HTMLCSStoImage are medium-confidence display-ad entries.
