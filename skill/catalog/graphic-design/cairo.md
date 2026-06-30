# Cairo (pycairo / cairosvg)

## Summary
Cairo is a mature C 2D vector graphics library (antialiased paths, text, gradients, image compositing) that renders to multiple backends. From Python it is driven two ways: **pycairo** (low-level object bindings to the cairo C API — you draw imperatively and write to ImageSurface/PNG, SVGSurface, PDFSurface, PSSurface) and **CairoSVG** (a higher-level converter that rasterizes/transcodes existing SVG 1.1 to PNG, PDF, PS, or cleaned SVG). Output is fully deterministic and headless (no display server needed), making it a good fit for code-as-deliverable rendering. The primary OOTA deliverable kind is **image** (PNG), though it also natively emits SVG and PDF surfaces. As of 2026 both packages require Python >=3.10; pycairo targets cairo >=1.15.10. On macOS the native cairo lib (1.18.4 here) comes from Homebrew.

## Skills
| Name | Type | Official | License | URL |
|---|---|---|---|---|
| No official Anthropic/Claude skill for Cairo | none | no | — | https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview |
| pycairo official docs | documentation | yes (pygobject / Christoph Reiter et al.) | LGPL-2.1 / MPL-1.1 | https://pycairo.readthedocs.io/en/latest/ |
| CairoSVG official docs | documentation | yes (Kozea / CourtBouillon) | LGPL-3.0-or-later | https://cairosvg.org/documentation/ |
| cairo graphics library docs | documentation | yes (cairographics.org) | LGPL-2.1 / MPL-1.1 | https://www.cairographics.org/documentation/ |

No Anthropic-authored or Claude marketplace skill exists for Cairo/pycairo/cairosvg as of 2026-06. Drive it directly via the documented Python APIs. Sources: pycairo https://github.com/pygobject/pycairo, CairoSVG https://github.com/Kozea/CairoSVG.

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| Python (CPython >=3.10 / PyPy3) — **pycairo** | `brew install cairo pkg-config && pip install pycairo` | `import cairo`; create a Surface (ImageSurface/SVGSurface/PDFSurface), draw via a Context, then `surface.write_to_png(...)` or `surface.finish()`. Native cairo (>=1.15.10) + pkg-config required to build the wheel. PyPI: https://pypi.org/project/pycairo |
| Python (CPython >=3.10) — **CairoSVG** | `brew install cairo libffi pkg-config && pip install CairoSVG` | Library: `import cairosvg; cairosvg.svg2png(url='in.svg', write_to='out.png')` (also `svg2pdf`, `svg2ps`, `svg2svg`). CLI: `cairosvg in.svg -o out.png`. Built on cairocffi (needs cairo + FFI headers). PyPI: https://pypi.org/project/CairoSVG |
| Python (CPython) — **cairocffi** (alternative binding) | `pip install cairocffi` | ctypes/cffi binding (no C compile of the binding itself); the backend CairoSVG depends on. Use when you want pure-Python bindings instead of pycairo's C extension. Docs: https://cairocffi.readthedocs.io |

## Artifact kind
**image** (PNG). Surfaces map cleanly to OOTA kinds: ImageSurface→image(png), SVGSurface→svg, PDFSurface→pdf.

## Validation
**Install:**
```bash
brew install cairo pkg-config libffi && pip install pycairo CairoSVG
```
**Smoke:**
```bash
python3 - <<'PY'
import cairo, cairosvg, os
# pycairo: draw a red circle to PNG
s = cairo.ImageSurface(cairo.FORMAT_ARGB32, 200, 200)
c = cairo.Context(s)
c.set_source_rgb(1,1,1); c.paint()
c.set_source_rgb(0.85,0.1,0.1); c.arc(100,100,70,0,6.2832); c.fill()
s.write_to_png('out_pycairo.png')
# cairosvg: transcode an SVG string to PNG
svg='<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="steelblue"/></svg>'
cairosvg.svg2png(bytestring=svg.encode(), write_to='out_cairosvg.png')
print('exists', os.path.getsize('out_pycairo.png')>0, os.path.getsize('out_cairosvg.png')>0)
PY
```
**Expect:** Two PNG files written (out_pycairo.png, out_cairosvg.png), both non-zero size; stdout prints `exists True True`. Fully headless on macOS — no display/X server required. `file out_pycairo.png` reports a 200x200 PNG.

## Wrapper params
- `graphic-design.title` (text) — label drawn into the rendered image.
- `graphic-design.mode` (select: pycairo | cairosvg) — imperative draw vs SVG transcode.
- `graphic-design.bg` (color) — background fill.

## Component / explorer notes
Deterministic: same draw calls / same input SVG produce byte-stable raster output (no randomness, no network). pycairo is **imperative** — author the drawing as a Python script (the version-controllable artifact); the `.py` is the source, the `.png`/`.svg`/`.pdf` is the rendered deliverable. CairoSVG is **declarative** — author or generate an `.svg`, then transcode. Text rendering depends on installed fonts, so pin fonts (via fontconfig / bundled `.ttf` and toy_font or `fc-cache`) for reproducible glyphs across machines.

**Wrapper guidance:** Wrap as a thin Python CLI: take a draw-spec or `.svg` input path + output path, call `write_to_png`/`svg2png`, exit nonzero on cairo error (pycairo raises exceptions on bad surface status). Pin versions in requirements (pycairo, CairoSVG) and document the native dep (`brew install cairo pkg-config libffi`) — the most common failure is a missing system cairo/FFI at wheel-build time. For headless CI/macOS no extra display setup is needed. Prefer pycairo when generating art procedurally from data; prefer CairoSVG when the authoring format is SVG markup and you only need a faithful raster/PDF render. Both are LGPL — fine to invoke as a subprocess/library without copyleft contamination of caller code.
