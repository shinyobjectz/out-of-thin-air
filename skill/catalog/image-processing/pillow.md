<!-- generated draft — needs validation -->
# pillow

## Summary
Pillow (PIL Fork) is the de-facto Python imaging library — deterministic, scriptable
image creation and manipulation: resize, crop, convert, draw, composite, and format
conversion across PNG/JPEG/WebP/GIF/TIFF/etc. Latest stable is 12.2.0 (June 2026);
11.3.0 verified working locally on this macOS box. It is driven entirely from Python
code, which makes it an ideal fit for OOTA's deterministic, version-controllable
authoring model: a `.py` script renders headlessly to an image file with no GUI/display
dependency. Primary artifact kind is **image** (raster). Verified headless smoke on
macOS emits a valid PNG.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| image-processing (jezweb/claude-skills) | skill | community | Check repo (jezweb/claude-skills) — community-maintained | https://github.com/jezweb/claude-skills/blob/main/plugins/design-assets/skills/image-processing/SKILL.md |
| Claude Cookbook — image crop tool (multimodal) | reference | official | Anthropic Cookbook | https://platform.claude.com/cookbook/multimodal-crop-tool |
| Pillow official documentation | docs | official | MIT-CMU (HPND/PIL Software License) | https://pillow.readthedocs.io/en/stable/ |

Attribution:
- jezweb/claude-skills community plugin; ships an `img-process` CLI in `bin/` plus
  Pillow-script generation for custom workflows (resize, crop, trim, format convert
  PNG/WebP/JPG, thumbnails, OG cards, chroma-key bg removal, watermarks).
- Anthropic official cookbook; demonstrates giving Claude a Pillow-backed crop tool
  for better image analysis.
- python-pillow project; canonical API reference and handbook/tutorial.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.9+, 3.13 supported in 12.x) | `pip install pillow` (or `uv pip install pillow`) | `python script.py` |

Notes: import as `from PIL import Image, ImageDraw, ImageFont, ImageFilter`. Prebuilt
wheels for macOS arm64/x86_64 — no system libs needed for common formats. Fully
headless — no display/GUI required for `save()`/`open()`/`transform()`. Deterministic
output for fixed inputs. Pillow ships no native CLI of its own; community skills wrap
it with their own CLI.

## Artifact kind
`image` (raster bitmap). Pillow operates on pixel buffers and emits bitmap files; it
does NOT produce vector output (no SVG) — for SVG use a different tool.

## Validation
- install: `pip install pillow`
- smoke:
  ```bash
  python3 -c "from PIL import Image, ImageDraw; img=Image.new('RGB',(200,100),'#1e293b'); d=ImageDraw.Draw(img); d.rectangle([20,20,180,80],outline='#38bdf8',width=3); img.save('out.png')"
  ```
- expect: exits 0 and writes `out.png`; `file out.png` reports
  `PNG image data, 200 x 100, 8-bit/color RGB, non-interlaced`. Verified on macOS
  (Darwin 24.6) with Pillow 11.3.0.

## Wrapper params
- `image-processing.title` (text) — text drawn onto the image.
- `image-processing.width` (range) — output width in px.
- `image-processing.height` (range) — output height in px.
- `image-processing.bg` (color) — background fill.
- `image-processing.fg` (color) — foreground/outline color.

Wrap as a thin Python script entrypoint that takes parameters (dimensions, text,
paths) and writes one image file to a known output path — no interactive/display
calls. Pin `pillow==12.2.0` (or chosen version) in requirements for reproducible
renders; output bytes can drift across Pillow/libjpeg/freetype versions, so lock the
toolchain. Bundle TTF/OTF font files in-repo and load via `ImageFont.truetype` rather
than relying on system fonts. Prefer PNG (lossless, deterministic) as the canonical
artifact; JPEG/WebP encoders may vary by build. Headless-safe by default on
macOS/Linux; no extra env needed.

## Component / explorer notes
Pillow is a raster image engine: it operates on pixel buffers (`Image` objects) and
emits bitmap files. Core deterministic primitives for OOTA components:
`Image.new`/`open`/`save`, `ImageDraw` (shapes/text), `ImageFont.truetype` (bundle
fonts for reproducibility — system-font fallback is non-deterministic), `ImageFilter`,
`paste`/`composite`/`alpha_composite`, `resize`/`crop`/`rotate`/`transform`. Font
rendering and resampling are deterministic given identical Pillow + freetype versions;
pin the version for byte-stable output.
