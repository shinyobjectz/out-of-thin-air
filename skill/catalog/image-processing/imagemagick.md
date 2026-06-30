# ImageMagick (MSL) — image-processing

<!-- generated draft — needs validation -->

## Summary

ImageMagick is a 260+ format raster image processing engine. Its deterministic,
version-controllable authoring surfaces are (1) the `magick` CLI pipeline (and
`-script` files), and (2) MSL (Magick Scripting Language), an XML markup
interpreted by the `conjure` program or the `msl:` coder. MSL declaratively
chains read/process/write actions and is the closest match to OOTA's
"code/markup renders headlessly to a file" model.

CAVEAT (verified on this machine): MSL is broken on the current Homebrew IM7
build (7.1.2-13 Q16-HDRI) — both `conjure script.msl` and
`magick msl:script.msl out.png` fail (`ReadMVGImage 'must specify image size'`;
`msl.c MSLStartElement` error 7054), even though MSL/SVG/MVG are listed as `rw+`
formats. The standard `magick` CLI emits files reliably and deterministically;
that is the recommended OOTA driver, with MSL XML as an aspirational markup that
needs a known-good build (or older IM6 `conjure`) to be dependable.

Primary deliverable kind is **image** (PNG/JPG/WebP/TIFF/etc.); can also emit
pdf/svg.

## Skills

| Name | Type | URL | Official | License / Attribution |
|---|---|---|---|---|
| anthropics/skills (official Agent Skills repo) | skill-repo | https://github.com/anthropics/skills | yes | Repo LICENSE; Anthropic. No dedicated ImageMagick/MSL skill as of 2026-06 — check for a media/image-processing skill. |
| oaustegard/claude-skills — processing-images | community-skill | https://github.com/oaustegard/claude-skills/blob/main/processing-images/SKILL.md | no | MIT-style (verify); oaustegard |
| jezweb/claude-skills — design-assets/image-processing | community-skill | https://github.com/jezweb/claude-skills/blob/main/plugins/design-assets/skills/image-processing/SKILL.md | no | Repo license (verify); jezweb |
| Official ImageMagick docs: conjure / MSL | docs | https://imagemagick.org/script/conjure.php | yes | ImageMagick License (Apache-2.0-compatible); ImageMagick Studio LLC |

## Toolchains

| Lang | Install | Invoke / Notes |
|---|---|---|
| shell | `brew install imagemagick` (full delegates: `brew install imagemagick-full`, keg-only) | `magick INPUT [options] OUTPUT`. MSL: `conjure script.msl` OR `magick msl:script.msl out`. Primary OOTA driver. conjure/msl: broken on Homebrew 7.1.2-13; CLI pipeline works. Verify: `magick --version` |
| python | `brew install imagemagick && pip install Wand` | `from wand.image import Image` — ctypes binding to MagickWand C API, deterministic in-process |
| php | `brew install imagemagick && pecl install imagick` | `$im = new Imagick();` — native MagickWand binding |
| perl | `cpan Image::Magick` (needs IM dev headers) | PerlMagick — historical scripting front-end; MSL was designed as a no-Perl alternative |
| node | `brew install imagemagick && npm install imagemagick` | Shell wrapper around the binary, not a native binding. `sharp` is libvips, a different engine. |

## Artifact kind

**image** (raster: PNG/JPG/WebP/TIFF/GIF; also PDF and SVG output).

## Validation

- **install**: `brew install imagemagick && magick --version`
- **smoke**:
  ```bash
  cd /tmp && magick -size 200x100 gradient:navy-white \
    -draw "fill red circle 100,50 100,20" smoke.png && magick identify smoke.png
  # MSL path (may fail on broken builds):
  printf '<?xml version="1.0"?>\n<image>\n<read filename="/tmp/smoke.png"/>\n<resize geometry="100x50"/>\n<write filename="/tmp/msl-out.png"/>\n</image>\n' > /tmp/s.msl
  conjure /tmp/s.msl && magick identify /tmp/msl-out.png
  ```
- **expect**: CLI smoke writes `/tmp/smoke.png`; `identify` prints
  `smoke.png PNG 200x100 ... sRGB`. VERIFIED working headless on macOS
  (Apple Silicon, IM 7.1.2-13). MSL conjure/msl: leg currently ERRORS on
  Homebrew 7.1.2-13 (`must specify image size` / `MSLStartElement 7054`) —
  needs a freetype/xml-complete or IM6 build to pass.

## Wrapper params

- `image-processing.title` — text, label "Title" (used as overlay text if text
  rendering is available).
- `image-processing.size` — text, canvas geometry (e.g. `800x400`).
- `image-processing.bg` — color, background/gradient start.
- `image-processing.format` — select: png | jpg | webp | tiff.

## Component / explorer notes

- MSL is XML markup with action elements (`read`, `get`, `resize`, `crop`,
  `annotate`, `composite`, `write`) plus attributes — declarative, diffable,
  fully version-controllable, headless. Deterministic given fixed
  inputs/options.
- For reproducible hashes: `-strip` metadata and pin `-define` options to avoid
  timestamp-driven byte differences.
- This Homebrew build's Delegates: bzlib heic jng jpeg lcms ltdl lzma png tiff
  webp xml zlib zstd — NO freetype/ghostscript, so text annotation
  (`-annotate`/`-draw text`) fails until `imagemagick-full` (or
  freetype+ghostscript) is installed.
- OOTA wrapper guidance: prefer `magick` over deprecated `convert`; probe MSL
  availability and fall back to CLI pipeline if it errors; require
  `imagemagick-full` when text rendering is needed; add `-strip` + pinned
  `-define` for byte-stable artifacts; treat `.msl` as a markup format only on
  builds where the probe passes. If declarative XML markup is mandatory, pin to
  an IM6 `conjure` or a container with a verified MSL build.
