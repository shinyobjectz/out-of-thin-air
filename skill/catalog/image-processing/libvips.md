# libvips

## Summary
libvips is a fast, low-memory, demand-driven image processing library. Latest stable is 8.18.x (8.18.0 released 2025-12-17; 8.18.1 adds Windows binaries). It ships a C/C++ API plus a command-line interface (the `vips` driver and `vipsthumbnail`) and is the engine behind Node's sharp. Supports JPEG, PNG, WebP, TIFF, GIF, HEIC/AVIF, JPEG XL, JPEG 2000, PDF, SVG, FITS, OpenEXR, OpenSlide, DeepZoom and more. Fully deterministic, headless, scriptable from code on macOS via Homebrew. Primary deliverable kind: **image** (raster/pyramidal). It can rasterize/convert PDF and SVG inputs, but its OUTPUT artifact is always an image.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| libvips-image | community | no | unverified (listing HTTP 403) | https://lobehub.com/skills/openclaw-skills-libvips-image |
| libvips official docs / CLI reference | docs | yes | LGPL-2.1 (lib); docs CC | https://www.libvips.org/API/current/ |
| libvips GitHub (source + releases + bindings wiki) | docs | yes | LGPL-2.1-or-later | https://github.com/libvips/libvips |

No official Anthropic/Claude skill exists. Only skill-shaped asset found is the unverified community LobeHub listing (openclaw-skills) — license unknown. Authoritative references are the official libvips API docs and GitHub. Bindings index: https://github.com/libvips/libvips/wiki/Language-bindings

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| shell/CLI | `brew install vips` | `vips <operation> in out [args]`; `vipsthumbnail` for fast resize/convert. Canonical deterministic driver. |
| Python | `brew install vips && pip install pyvips` (or `pip install pyvips[binary]` for self-contained wheel) | `import pyvips; pyvips.Image.<op>(...)`. `[binary]` extra bundles libvips (no brew). |
| JavaScript/Node | `npm install sharp` (prebuilt libvips bundled) | `require('sharp')(input).resize(...).toFile('out.png')`. No brew needed. |
| Ruby | `brew install vips && gem install ruby-vips` | ruby-vips 2.0 API; Linux/macOS/Windows, incl JRuby. |
| Go | `brew install vips && go get github.com/davidbyttow/govips/v2/vips` | cgo binding; needs libvips dev headers (brew provides). |
| PHP/.NET/Lua/Crystal/Elixir/Java/Nim | `brew install vips` + per-language package (jcupitt/vips, NetVips, Vix, ...) | various FFI/native; see bindings wiki. |

## Artifact kind
**image** — raster/pyramidal output. Even with PDF/SVG inputs, libvips rasterizes to a raster image; map to `image`, not pdf/svg.

## Validation
- **install:** `brew install vips`
- **smoke:** `vips black /tmp/oota_libvips.png 256 256 && vips colourspace /tmp/oota_libvips.png /tmp/oota_libvips_rgb.png srgb && vipsheader /tmp/oota_libvips.png && file /tmp/oota_libvips.png`
- **expect:** Exit 0. `/tmp/oota_libvips.png` exists; `file` reports `PNG image data, 256 x 256`; `vipsheader` prints `256x256 uchar, 1 band, b-w, pngload`. Fully headless on macOS, no display server needed.

## Wrapper params
- `image-processing.title` (text) — label/filename stem for the generated image.
- `image-processing.width` (range) — output width in px.
- `image-processing.height` (range) — output height in px.
- `image-processing.colour` (color) — fill colour for the generated raster.

## Component / explorer notes
Prefer the CLI as the canonical wrapper: deterministic, version-controllable shell invocations that emit a file. Every operation is reachable as `vips <op> in out [args]`; output is byte-stable for the same inputs; runs headless. Pin the libvips version (brew pins or sharp's bundled version) — operation defaults and format support evolve across minor releases (e.g. 8.18 added dcrawload/UltraHDR). `pyvips[binary]` and `sharp` are the two toolchains that DON'T need a system libvips (they bundle their own) — useful for hermetic builds.
