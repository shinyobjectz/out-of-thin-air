<!-- generated draft — needs validation -->
# DrawBot

## Summary
DrawBot is a Python 2D-graphics scripting environment: you write deterministic
Python that calls drawing primitives (rects, ovals, bezier paths, text with full
OpenType/variable-font control, transparency) and export to PDF, SVG, PNG, JPEG,
TIFF, animated GIF, or MP4. Two distinct runtimes exist:

1. **typemytype/drawbot** — original macOS-only app + pip module built on
   CoreGraphics/AppKit (PyObjC). Reference implementation, richest typographic +
   animation API. Not portable to Linux.
2. **justvanrossum/drawbot-skia** — cross-platform pure-Python *subset* backed by
   Skia, `pip install drawbot-skia`. Ships a `drawbot` CLI that renders a script
   headlessly to an output file (no GUI, no explicit `saveImage()` needed). Ideal
   for OOTA's deterministic, version-controllable, headless authoring model.

Source is plain `.py`, fully diffable. No official Anthropic/DrawBot Claude skill
exists; closest are community generative-art/canvas-design skills (p5.js), useful
only as structural templates — the skill layer is a custom wrapper.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| (none for DrawBot) | none | no | n/a | https://www.drawbot.com/ (canonical API ref) |
| algorithmic-art / canvas-design (community generative-art) | community | no | varies per repo | https://github.com/travisvn/awesome-claude-skills |

No Anthropic/Claude skill targets DrawBot specifically. drawbot.com is the
canonical API reference for a custom wrapper skill. Community generative-art
skills target p5.js / generic canvases, NOT DrawBot — template only.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (drawbot-skia, Skia backend — recommended, headless macOS/Linux) | `pip install drawbot-skia` | `drawbot script.py out.pdf` (CLI, no import/saveImage needed) or `import drawbot_skia.drawbot as db; db.saveImage('out.pdf')` |
| Python (DrawBot original, macOS-only, CoreGraphics/AppKit via PyObjC) | `pip install git+https://github.com/typemytype/drawbot` (macOS only) or `.app` from drawbot.com | `import drawBot as db; db.saveImage('out.pdf')` |

drawbot-skia: Apache-2.0, 64-bit Python 3.x, implements a SUBSET of the full API.
Original drawBot: Python 3.11+, fullest typographic + multi-page + MP4 API,
requires macOS frameworks (not Linux-portable).

## Artifact kind
**pdf** — primary deliverable is a vector PDF (also emits svg/png/jpeg/tiff/gif/mp4
by output extension).

## Validation
- **install:** `pip install drawbot-skia`
- **smoke:**
  ```
  printf 'size(200,200)\nfill(0,0,1)\nrect(20,20,160,160)\nfill(1)\nfontSize(40)\ntext("OOTA", (40,90))\n' > /tmp/d.py && drawbot /tmp/d.py /tmp/out.pdf && ls -la /tmp/out.pdf
  ```
- **expect:** Command exits 0 with no GUI; `/tmp/out.pdf` created (non-zero size)
  as a 200x200 vector PDF with a blue square and white text "OOTA". Swap output
  extension (out.png / out.svg) to verify raster and SVG emitters. Fully headless
  on macOS.

## Wrapper params
- `graphic-design.title` (text) — title text drawn into the canvas.
- Output kind selected by file extension (pdf/svg/png/mp4).
- Wrapper standardizes on drawbot-skia (Apache-2.0, pip, headless CLI) for
  portable rendering; falls back to original drawBot module only for macOS-only
  features (advanced OpenType, MP4). Invoke `drawbot <script.py> <out.{pdf|svg|png|mp4}>`.
  Pin drawbot-skia version + embedded fonts. Validate scripts against the SUBSET,
  not the full drawbot.com API.

## Component / explorer notes
Deliverable is a single deterministic `.py` DrawBot script (plain text, diffable).
Rendering is reproducible given pinned fonts + drawbot-skia version. Multi-page PDF
via `newPage()` per page; for animation each `newPage()` is a frame exported to
GIF/MP4. Determinism caveats: seed any `random()`; text layout depends on exact
font files present — vendor fonts into the repo and reference by path, not by
installed family name.
