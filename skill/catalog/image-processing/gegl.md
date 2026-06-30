<!-- generated draft — needs validation -->
# GEGL (image-processing / gegl)

## Summary
GEGL (Generic Graphics Library) is GIMP's graph-based, non-destructive image-processing engine. Deterministic operation graphs are authored either as XML compositions or as one-line `gegl-chain` pipelines, then rendered headlessly to a raster file via the `gegl` CLI (`-o out.png`). Operations cover load/store, color adjustment, blurs, distorts, GIMP artistic filters, compositing, and more. The graph (XML or `.gegl` chain text) plus the CLI invocation are fully version-controllable and reproducible for a fixed input + op params, fitting OOTA's deterministic-codegen model. Actively maintained (docs updated April 2025).

## Skills
No official Anthropic/Claude skill exists. Drive GEGL as a plain CLI/library.
- Project site: https://gegl.org/ (community / GNOME, official project docs)
- Operation reference: https://gegl.org/operations/ (community / official)
- License: mixed — LGPL-3.0-or-later AND GPL-3.0-or-later AND BSD-3-Clause AND MIT (per Homebrew formula). GPL components matter if redistributing binaries.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| shell/CLI | `brew install gegl` | `gegl in.png -o out.png -- gaussian-blur std-dev-x=8 std-dev-y=8` (gegl-chain one-liner) or `gegl graph.xml -o out.png`. Discover ops: `gegl --list-all`; inspect: `gegl --info <op>`. Output format inferred from `-o` extension. |
| C | `brew install gegl` | `#include <gegl.h>`; build a `GeglNode` graph, `gegl_node_process` on a png-save node. Compile: `cc demo.c $(pkg-config --cflags --libs gegl-0.4)`. Native API; everything the CLI does is exposed here. |
| Python | `brew install gegl pygobject3` | `Gegl.init()`; build nodes via `Gegl.Node`, process to a `gegl:png-save` sink. `python -c 'import gi; gi.require_version("Gegl","0.4"); from gi.repository import Gegl'`. Depends on the GIR typelib on `GI_TYPELIB_PATH`; less common than the CLI. |

## Artifact kind
**image** (PNG/JPEG/TIFF/...). Output format chosen by the `-o` file extension.

## Validation
- install: `brew install gegl`
- smoke: `gegl -o /tmp/gegl-smoke.png -- checkerboard color1='rgb(0,0,0)' color2='rgb(1,1,1)' gaussian-blur std-dev-x=4 std-dev-y=4 crop width=256 height=256 ; file /tmp/gegl-smoke.png`
- expect: command exits 0 and `/tmp/gegl-smoke.png` exists as a valid PNG (`file` reports `PNG image data`). Fully headless on macOS, no display needed.

## Wrapper params
- `image-processing.title` (text) — label/name for the composition.
- `image-processing.chain` (textarea) — gegl-chain op spec appended after `--` (e.g. `gaussian-blur std-dev-x=8 std-dev-y=8`).
- `image-processing.format` (select: png/jpg/tif) — output extension drives encoder.

## Component / explorer notes
A deliverable = a GEGL graph (XML composition file) or a gegl-chain text pipeline plus the source input image(s). The graph is the version-controllable artifact; rendering is deterministic for a fixed input + op params. Treat each chain/XML as a component definition; ops are nodes with typed properties (set as `property=value`). Use `gegl --list-all` / `gegl --info <op>` to discover the op vocabulary. Pin the `gegl` (and `babl`) version for reproducibility — op defaults can shift across releases. Wrap the CLI: accept input image + chain/XML spec, run `gegl <input> -o <output> -- <ops>` (or `gegl spec.xml -o out.png`), return the emitted file.
