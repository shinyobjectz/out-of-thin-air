# python-barcode

## Summary
python-barcode is a pure-Python library (v0.16.1, MIT, released 2025-08-27) for generating standard 1D barcodes: EAN-8/13/14, UPC-A, JAN, ISBN-10/13, ISSN, Code 39, Code 128, PZN, Gs1-128, ITF, Codabar. SVG is the default, dependency-free, deterministic output; raster (PNG and other Pillow-backed formats) requires the optional Pillow ImageWriter. Fits OOTA as deterministic, version-controllable code that renders headlessly to SVG (primary) or PNG. Supports Python 3.9-3.12.

## Skills
No official Anthropic/Claude skill and no notable dedicated community skill exists for python-barcode (as of 2026-06). Authoring is direct library/CLI use against upstream docs.
- Docs (community/official project): https://python-barcode.readthedocs.io/ — official project docs, no license restriction on use
- Source: https://github.com/Whic/python-barcode — MIT

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Python (CPython 3.9-3.12) | `pip install python-barcode` (SVG only, zero deps); `pip install "python-barcode[images]"` (adds Pillow for PNG/raster) | Library: `from barcode import EAN13; from barcode.writer import SVGWriter; EAN13('5901234123457', writer=SVGWriter()).save('out')`. CLI: `python-barcode create '123456789102' outfile -b code128 -f png` |

SVGWriter is the default writer and emits deterministic dependency-free SVG. ImageWriter needs Pillow.

## Artifact kind
svg (primary deterministic output; PNG/raster optional via Pillow ImageWriter)

## Validation
- **install**: `python3 -m venv /tmp/pbc && /tmp/pbc/bin/pip install python-barcode`
- **smoke**: `/tmp/pbc/bin/python -c "from barcode import EAN13; from barcode.writer import SVGWriter; EAN13('5901234123457', writer=SVGWriter()).save('/tmp/barcode_out')" && ls -la /tmp/barcode_out.svg && head -c 120 /tmp/barcode_out.svg`
- **expect**: Creates /tmp/barcode_out.svg (a valid `<svg>` document, a few KB) with no errors; head shows `<?xml ...` / `<svg`. Fully headless on macOS, no Pillow needed for SVG. For PNG: install `"python-barcode[images]"` and pass `writer=ImageWriter()`, save() yields /tmp/barcode_out.png.

## Wrapper params
Deterministic input is the data string + barcode type + writer options. EAN/UPC writers auto-compute the trailing check digit. Writer options (`writer.set_options` / kwargs): `module_height`, `module_width`, `quiet_zone`, `font_size`, `text_distance`, `write_text`. Pin version 0.16.1 since glyph/font rendering of the human-readable text can vary across releases.

## Component/explorer notes
Drive headlessly via a tiny Python wrapper or the bundled `python-barcode` CLI. Prefer SVGWriter for OOTA: pure-text, diffable, version-controllable, zero binary/font dependencies. Note `save()` appends the extension automatically (pass the path WITHOUT extension). For PNG add the `[images]` extra (Pillow); on macOS Pillow wheels install cleanly with no system libs. SVG can be post-rendered to PDF/PNG with a separate headless converter if a different artifact kind is needed.
