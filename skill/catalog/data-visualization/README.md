# data-visualization

Charts and plots authored as code or spec, rendered headless to svg/png/pdf — no browser, no GUI, no network.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [Vega-Lite (vl-convert)](./vega-lite.md) | image (png) | Rust CLI `vl-convert`, Python `vl-convert-python`, Rust lib `vl-convert-rs`, Elixir `vega_lite_convert` | charting-vega-lite (Claude built-in skill) | yes | ok | yes | yes |
| [Observable Plot](./observable-plot.md) | svg | JS/Node ESM (`@observablehq/plot` + `d3` + `jsdom`) | Observable Plot official docs | yes | ok | yes | yes |
| [Matplotlib](./matplotlib.md) | image (png/svg/pdf) | Python 3.10+ (primary), Julia PythonPlot/PyPlot (secondary) | data-visualization (Anthropic knowledge-work skill) | yes | ok | yes | yes |
| [ggplot2](./ggplot2.md) | image (png/svg) | R (`ggplot2` + `svglite`) | llm-r-skills (ggplot2 skill) | no | ok | yes | yes |
| [gnuplot](./gnuplot.md) | svg | shell/CLI, Python, any | none | no | ok | yes | yes |
| [Plotly (Kaleido)](./plotly.md) | image (png) | Python (`plotly`>=6.1.1 + `kaleido`>=1.0), R, JS/Node | Plotly Python docs — Static Image Export | yes | ok | yes | yes |
| [Apache ECharts](./echarts.md) | svg | Node 18+ SSR (canonical), +node-canvas (PNG), mcp-echarts, @resvg/resvg-js | ECharts Handbook — Server Side Rendering | yes | ok | yes | yes |

All 7 tools build clean (status ok), each with a dossier, a `.work` wrapper, and a `tools/steps/*.sh` step script. Every step script graceful-degrades to a hint when its runtime is absent. No shared files (Justfile, catalog.work, router.work) were touched.

## Multi-toolchain notes

- **Vega-Lite** is the most polyglot: a single `.vl.json` spec renders identically via Rust CLI, Python, Rust lib, or Elixir. Wrapper pins `--vl-version 5.20` for determinism.
- **Plotly** carries the sharpest gotcha: Kaleido v1 no longer bundles Chrome — `plotly_get_chrome` must run once before any `write_image`, or export hangs/fails. This is the #1 failure mode, flagged in both wrapper and step.
- **Matplotlib** must force the headless Agg backend (`MPLBACKEND=Agg` / `matplotlib.use('Agg')`) to run without a display on macOS; it is the only entry with native png + svg + pdf out of one script.
- **ECharts** and **Observable Plot** are Node/ESM SSR vector renderers — deterministic class names keep output byte-stable and diffable across runs. ECharts gets PNG via an optional node-canvas / resvg raster step.
- **ggplot2** and **gnuplot** are the two non-official-skill tools; both are deterministic (set.seed / fixed spec) and render via a single interpreter invocation (`Rscript` / piped `gnuplot`).

## Validation order

Run cheapest / most-reliable installs first; defer the heavyweight or Chrome-dependent ones:

1. **gnuplot** — `brew install gnuplot`; single binary, pipe a script, emits SVG. No language runtime.
2. **Vega-Lite** — `pip install vl-convert-python` (or `cargo install vl-convert`); self-contained, headless, no browser/network.
3. **Matplotlib** — `pip install matplotlib`; pure-Python wheel, Agg backend, instant PNG.
4. **Observable Plot** — `npm install @observablehq/plot d3 jsdom`; Node ESM, no native build.
5. **Apache ECharts** — `npm install echarts`; Node SSR SVG, no native deps (PNG path adds node-canvas).
6. **ggplot2** — `brew install r` + `install.packages(c("ggplot2","svglite"))`; R toolchain + CRAN pull is slower.
7. **Plotly (Kaleido)** — venv + `pip install plotly kaleido` + **`plotly_get_chrome -y`**; heaviest (downloads Chrome), validate last.

## Explorer needs

The default shell explorer suffices for all current tools (each is a headless code/spec → file render). Candidates that would benefit from a richer explorer than the default shell:

- **Vega-Lite / ECharts / Observable Plot** — spec/JSON-first tools where a live spec editor with inline preview (paste spec → see rendered SVG/PNG) would beat blind shell re-runs.
- **Plotly** — a Chrome/Kaleido health-check panel would catch the `plotly_get_chrome` failure mode before render.

None are blocking; all validate via shell + `file`/`qlmanage` today.

## Dossiers

- [vega-lite.md](./vega-lite.md)
- [observable-plot.md](./observable-plot.md)
- [matplotlib.md](./matplotlib.md)
- [ggplot2.md](./ggplot2.md)
- [gnuplot.md](./gnuplot.md)
- [plotly.md](./plotly.md)
- [echarts.md](./echarts.md)
