# Vega-Lite (vl-convert) — data-visualization

## Summary
Vega-Lite is a declarative JSON grammar for statistical charts. **vl-convert** is the canonical headless renderer: a self-contained Rust library (`vl-convert-rs`), CLI (`vl-convert`), and Python binding (`vl-convert-python`) that compiles a Vega-Lite JSON spec to SVG, PNG, JPEG, or PDF with **no browser or Node.js runtime required**. It embeds minified Vega/Vega-Lite JS for multiple versions plus a Deno/V8 engine; PNG via the `resvg` crate, PDF via `svg2pdf` with font embedding. Fully deterministic from a version-controllable JSON spec, no network needed. Ideal OOTA fit: author chart as JSON, render headlessly to a file.

## Skills
| Name | Type | License | URL |
|------|------|---------|-----|
| charting-vega-lite (Claude built-in skill) | official | Anthropic terms | https://code.claude.com/docs/en/skills |
| anthropics/skills (public Agent Skills repo) | official | See repo LICENSE | https://github.com/anthropics/skills |
| Data Visualization Expert / Vega-Lite Chart Explorer | community | Varies per listing (unverified) | https://mcpmarket.com/tools/skills/vega-lite-chart-explorer |
| Vega-Lite official docs (grammar reference) | official | BSD-3-Clause | https://vega.github.io/vega-lite/ |

- Anthropic — built-in Vega-Lite charting skill in the Claude environment; renders specs into React-based artifacts with data inlined to bypass fetch restrictions.
- Anthropic — public skills repo; no dedicated vega-lite folder confirmed at research time, but the format/skill-creator pattern applies.
- Community contributors via MCP Market — transform datasets into validated Vega-Lite charts with type recommendation.
- UW Interactive Data Lab / Vega project — grammar reference.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Rust (CLI) | `cargo install vl-convert --locked` | `vl-convert vl2png -i in.vl.json -o out.png --vl-version 5.20 [--scale 2] [--theme dark]` |
| Python | `pip install vl-convert-python` | `import vl_convert as vlc; vlc.vegalite_to_png(vl_spec=spec, scale=2)` |
| Rust (library) | `cargo add vl-convert-rs` | Async `VlConverter` API; embeds Vega-Lite JS + V8 |
| Elixir | add `{:vega_lite_convert, "~> 1.0"}` to mix.exs | `VegaLite.Convert` over the vl-convert Rust core |

CLI subcommands: `vl2svg`, `vl2png`, `vl2jpeg`, `vl2pdf`, `vl2vg`, `vl2url`, `vl2html`. Latest CLI crate ~1.7.x; `vl-convert-rs` lib ~1.9.x (2.0.0rc in progress). The Python wheel is dependency-free (PyO3), no browser/Node, and is Altair's default static-export engine.

## Artifact kind
**image** (PNG/JPEG primary). SVG and PDF kinds emit from the same spec by swapping the subcommand.

## Validation
- **Install:** `cargo install vl-convert --locked`  (OR: `pip install vl-convert-python`)
- **Smoke:**
  ```bash
  printf '{"$schema":"https://vega.github.io/schema/vega-lite/v5.json","data":{"values":[{"a":"A","b":28},{"a":"B","b":55},{"a":"C","b":43}]},"mark":"bar","encoding":{"x":{"field":"a","type":"nominal"},"y":{"field":"b","type":"quantitative"}}}' > /tmp/chart.vl.json && vl-convert vl2png -i /tmp/chart.vl.json -o /tmp/chart.png --vl-version 5.20 && file /tmp/chart.png
  ```
- **Expect:** `/tmp/chart.png` written; `file` reports "PNG image data". Fully headless on macOS (Apple Silicon + Intel), no browser, no network. SVG/PDF variants: swap `vl2png`->`vl2svg`/`vl2pdf` and the output extension.

## Wrapper params
- `data-visualization.title` — chart title (text)
- `data-visualization.spec` — the Vega-Lite JSON spec (textarea, bound to `src/chart.vl.json`)
- `data-visualization.vl_version` — pinned Vega-Lite version for determinism (text, default 5.20)
- `data-visualization.kind` — output kind: png / svg / pdf / jpeg (select)
- `data-visualization.scale` — hi-DPI raster scale (range)
- `data-visualization.theme` — built-in theme (select)

## Component / explorer notes
Deliverable is a Vega-Lite spec: a single declarative JSON document (a `.vl.json` file) with `$schema` pinned to a specific vega-lite version (e.g. `v5.json`). Inline data under `data.values` for determinism and offline rendering (avoid `data.url` network fetches). Pin `--vl-version` explicitly so renders reproduce across vl-convert releases. The spec is small, diffable, and version-control-friendly — the canonical OOTA source artifact.

Wrap by feeding the `.vl.json` spec to the vl-convert CLI (preferred for OOTA: single static self-contained binary, no Node/Python env) or to `vl_convert` Python. Map OOTA output kind to subcommand: image->`vl2png`/`vl2jpeg`, svg->`vl2svg`, pdf->`vl2pdf`. Use `--scale` for hi-DPI raster, `--theme` for built-in themes, `--vl-version` for determinism. For interactive/animated output use `vl2html` (kind=html), but that loses determinism. SVG output needs embedded fonts available for consistent text layout; the PDF path embeds fonts via svg2pdf.
