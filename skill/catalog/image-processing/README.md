# image-processing

Batch raster transform/synthesis pipelines as code → image. Author a deterministic, version-controllable recipe (CLI args, MSL/GMIC script, Node/Python source) that renders a raster image artifact headlessly.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|------------|---------------|-----------|--------|----------|-------|
| [sharp](./sharp.md) | image | JS/TS (Node, Bun, Deno) | sharp official docs (pixelplumbing) | yes | ok | yes | yes |
| [libvips](./libvips.md) | image | shell (vips/vipsthumbnail), Python (pyvips), Node (sharp), Ruby, Go, PHP/.NET/Lua/Crystal/Elixir/Java/Nim | libvips official docs / CLI reference | yes | ok | yes | yes |
| [pillow](./pillow.md) | image | Python | image-processing (jezweb/claude-skills) | no | ok | yes | yes |
| [gmic](./gmic.md) | image | shell, Python, C++ | G'MIC official reference (gmic.eu) | no | ok | yes | yes |
| [ImageMagick (MSL)](./imagemagick.md) | image | shell, Python, PHP, Perl, Node | oaustegard/claude-skills — processing-images | no | ok | yes | yes |
| [gegl](./gegl.md) | image | shell, C, Python | — (raw CLI, no skill) | no | ok | yes | yes |

## Multi-toolchain notes

- **CLI is the canonical deterministic driver** for the C-library tools (libvips, gmic, ImageMagick, gegl). Language bindings (pyvips, ruby-vips, govips, gmic Python wheels) lag the C release and add version skew — recipes pin via `brew` and prefer the CLI for reproducibility.
- **sharp** is the JS/TS-native path (Node/Bun/Deno); it is also one of libvips' bindings, so libvips and sharp share the same engine. Step writes a Node ESM source (`gen.mjs`) that composites an SVG title onto a created background.
- **ImageMagick**: MSL XML is emitted as version-controllable markup but is **broken on IM7 Homebrew** (`conjure`/`msl:` error 7054) — the CLI `magick` pipeline is the working OOTA driver. Uses `-strip` for byte-stable output. Text annotation requires `imagemagick-full` (default delegates lack freetype/ghostscript).
- **Determinism**: gmic injects `srand` seed for stochastic filters; ImageMagick strips metadata; all steps graceful-degrade with an install hint when the binary is absent.
- **gegl** is mixed-license (LGPL-3/GPL-3/BSD-3/MIT) — pin `gegl` + `babl` together.

## Validation order

Cheapest / most reliable installs first:

1. **pillow** — `pip install pillow` (pure-ish Python wheel, already present on macOS Darwin 24.6, Pillow 11.3.0 verified).
2. **sharp** — `npm install sharp` (prebuilt binaries, no system lib needed).
3. **libvips** — `brew install vips` (CLI verified, fast).
4. **gmic** — `brew install gmic`.
5. **gegl** — `brew install gegl` (pulls babl + GEGL stack).
6. **ImageMagick** — `brew install imagemagick`; needs `imagemagick-full` for text/freetype; MSL path known-broken on IM7.

## Explorer needs

All six render raster PNGs headlessly and verify with `file` / `identify` / `vipsheader` / sharp `metadata()` — the **default shell explorer suffices**. None require a richer (browser/GUI/display-server) explorer; gegl runs headless despite its GIMP lineage.

## Tool dossiers

- [sharp.md](./sharp.md)
- [libvips.md](./libvips.md)
- [pillow.md](./pillow.md)
- [gmic.md](./gmic.md)
- [imagemagick.md](./imagemagick.md)
- [gegl.md](./gegl.md)
