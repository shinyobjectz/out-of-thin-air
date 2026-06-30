<!-- generated draft — needs validation -->
# Plotly (Kaleido)

## Summary
Plotly is a declarative charting library (Python/R/JS) that defines figures as version-controllable code/JSON specs covering 40+ chart types (statistical, 3D, geo, financial). Kaleido is its headless static-export engine: it drives a headless Chrome instance (via the `choreographer` library since v1.0) to render a Plotly figure deterministically to PNG, JPEG, WebP (raster) or SVG/PDF (vector).

As of Kaleido v1.0.0 (2025-06-19), Chrome is no longer bundled — it must be installed separately via `plotly_get_chrome`. Latest Kaleido is v1.3.0 (2026-05-04). Plotly figures are pure code/data, so they are deterministic and diffable; Kaleido turns them into committed image/svg/pdf artifacts headlessly. Plotly can also emit standalone interactive HTML (`write_html`), but the deterministic file-emitting path for OOTA is the static raster/vector export via Kaleido.

Orca and Kaleido v0 are deprecated (removed after Sept 2025); use Kaleido v1 + plotly.py >= 6.1.1.

## Skills
- **Plotly (k-dense-ai)** — community, not official. https://www.skillsdirectory.com/skills/k-dense-ai-plotly — license: unspecified (community skill registry). Interactive scientific/statistical viz, Plotly Express vs Graph Objects guidance, 40+ chart types.
- **Anthropic 'data' plugin / Claude data-visualization skill** — official. https://www.claudepluginhub.com/plugins/anthropics-data-data — license: Anthropic (see repo). Claude generates Plotly charts in the secure Python sandbox (Custom Visuals in Chat, GA path).
- **Official Plotly Python docs — Static Image Export** — official docs. https://plotly.com/python/static-image-export/ — license: docs (MIT-licensed library). Plotly Technologies — canonical `write_image` / Kaleido / `plotly_get_chrome` reference.
- **claude-scientific-skills (ricable) — visualization skills** — community, not official. https://deepwiki.com/ricable/claude-scientific-skills/7-visualization-skills — license: see repo. Community scientific-skills repo bundling Plotly visualization helpers.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.8+) | `pip install --upgrade plotly kaleido && plotly_get_chrome` | `fig.write_image('out.png')` / `fig.to_image(format='png', scale=2)`; batch via `pio.write_images([...])` or `kaleido.Kaleido(n=4)` context manager |
| R | `install.packages('plotly')` + kaleido Python backend | `plotly::save_image(fig, 'out.png')` (wraps Kaleido via reticulate; needs Chrome) |
| JavaScript/Node | `npm install plotly.js-dist`; Kaleido standalone binary/CLI | plotly.js authors figure JSON; Kaleido CLI consumes figure JSON on stdin and emits image bytes. Python is best-supported driver |

Primary path is Python; pin `plotly>=6.1.1, kaleido>=1.0`. Requires Chrome (`plotly_get_chrome` or `pio.get_chrome()`).

## Artifact kind
**image** (PNG/JPEG/WebP raster). Vector variants: `.svg` -> svg, `.pdf` -> pdf; `.html` (`write_html`) -> html.

## Validation
- **install:** `python3 -m venv /tmp/plv && /tmp/plv/bin/pip install --upgrade plotly kaleido && /tmp/plv/bin/plotly_get_chrome -y`
- **smoke:** `/tmp/plv/bin/python -c "import plotly.express as px; px.bar(x=['a','b','c'], y=[1,3,2], title='OOTA smoke').write_image('/tmp/oota_plotly.png', width=600, height=400, scale=2)" && file /tmp/oota_plotly.png`
- **expect:** `plotly_get_chrome` downloads a headless Chrome; the python command exits 0 and writes `/tmp/oota_plotly.png`; `file` reports `PNG image data, 1200 x 800` (600x400 * scale 2). Swap extension to `.svg`/`.pdf` for vector. Fully headless on macOS — no display needed.

## Wrapper params
- `data-visualization.title` (text) — chart title.

## Component / explorer notes
A deliverable is a Plotly figure spec authored as Python (Plotly Express for quick figures, Graph Objects for fine control) or as raw figure JSON. The spec is fully declarative and deterministic — same code yields the same chart. Treat the `.py` source (or a `figure.json`) as the version-controlled component; the rendered `.png`/`.svg`/`.pdf` is a build artifact. Use `scale=` for DPI and explicit `width`/`height` to keep renders pixel-stable across machines.

Wrapper must: (1) create/locate a venv, install plotly+kaleido, and run `plotly_get_chrome` once (Kaleido v1 no longer bundles Chrome — #1 failure mode); pin `plotly>=6.1.1`. (2) Invoke `fig.write_image(path)` choosing extension by desired OOTA kind. (3) For batch renders use `pio.write_images()` or the `Kaleido(n=...)` context manager to amortize Chrome startup. (4) Set deterministic width/height/scale. (5) Cache the Chrome install path (CHROME via choreographer) to avoid re-downloading. Avoid deprecated Orca / Kaleido v0 codepaths.
