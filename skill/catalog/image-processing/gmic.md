# G'MIC (GREYC's Magic for Image Computing)

## Summary
G'MIC is a full-featured open-source image-processing framework exposing 4000+ functions/filters through its own scriptable G'MIC language. A pipeline string of chained commands transforms input images and emits output files headlessly — deterministic and version-controllable. The recipe (`.gmic` script / pipeline string) is the artifact; the rendered raster image is the deliverable. Driven from a shell CLI (`gmic`), from Python via the `gmic` PyPI binding, or embedded in C++ via `libgmic`. Latest CLI is 3.7.x (3.4.0 was a notable 2024/2025 release). Licensed CeCILL (free software). No official Anthropic/Claude skill exists — only community resources. macOS install via Homebrew (`brew install gmic`). Primary OOTA deliverable kind is **image** (also exports video frames and `.obj` 3D meshes, but raster image is canonical).

## Skills
| Name | Type | Official | License | URL |
|---|---|---|---|---|
| No official Anthropic/Claude skill for G'MIC | none | no | — | https://github.com/anthropics/skills |
| G'MIC official reference / list of commands | documentation | yes (GREYC Lab / D. Tschumperlé) | CeCILL / docs | https://gmic.eu/reference/list_of_commands.html |
| gmic-py docs (binding usage; NumPy/PIL/scikit-image interop) | documentation | yes (GreycLab / myselfhimself) | CeCILL | https://gmic-py.readthedocs.io/ |

No Anthropic-authored or Claude marketplace skill exists for G'MIC as of 2026-06. The anthropics/skills general repo contains no `gmic` skill. Author a custom skill from the gmic.eu reference if needed. Attribution: GREYC Lab / David Tschumperlé.

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| shell (gmic CLI binary) | `brew install gmic` | `gmic input.png -blur 3 -o output.png` — pipeline of chained commands; deterministic. Linux: distro pkg or build `make cli`. Latest 3.7.x. PyPI N/A. |
| Python (CPython 3) — `gmic` (PyPI) | `pip install gmic` | `import gmic; gmic.run('input.png blur 3 output output.png')`. C++ binding; interoperates with NumPy/PIL/scikit-image. PyPI build lagged (2.9.x era) — confirm wheel availability for current Python on macOS arm64; CLI is the more reliable headless driver. |
| C++ — `libgmic` (source) | build from https://gmic.eu/files/source/ (libgmic + CImg.h) | embed `gmic_library.h`; call `gmic(...)` with a pipeline string. For native integration. |

## Artifact kind
**image** (raster, e.g. PNG). Can also emit image sequences / video frames and `.obj` 3D meshes, but image is primary and canonical.

## Validation
**Install:**
```bash
brew install gmic
```
**Smoke:**
```bash
gmic 64,64,1,3 fill_color 255,128,0 -o /tmp/gmic_smoke.png && test -f /tmp/gmic_smoke.png && file /tmp/gmic_smoke.png
```
**Expect:** Generates a 64x64 RGB orange image with no input file; `/tmp/gmic_smoke.png` exists and `file` reports `PNG image data, 64 x 64`. Fully headless on macOS (no GIMP/X server required for the CLI). Exit code 0.

## Wrapper params
- `image-processing.title` (text) — label / used in the recipe comment and output naming.
- `image-processing.pipeline` (textarea) — the G'MIC command pipeline applied to the input (e.g. `fx_freaky_details 2,10,1,11,0,32,0`).
- `image-processing.seed` (text) — `srand` seed injected before stochastic filters for reproducibility.
- `image-processing.bg` (color) — background fill for from-scratch generation.

## Component / explorer notes
The deliverable is a raster image (or image sequence). The deterministic artifact OOTA should version-control is the `.gmic` pipeline script / command string (the recipe), NOT the binary PNG. Same script + same input = byte-stable output, given a fixed gmic version (pin via brew / version flag). Random-seed filters (noise, sketch) accept explicit seeds via `srand <seed>` — set seeds for determinism.

**Wrapper guidance:** Wrap as a thin shell adapter — take a `.gmic` recipe file (or inline pipeline) + input image path(s) + output path; shell out to `gmic <inputs> <pipeline> -o <output>`. Pin the gmic version for reproducibility and inject `srand <seed>` for any stochastic filter. Prefer the CLI over the Python binding for headless CI (binding wheels lag behind current Python). Validate output existence + format with `file`. For batch/generative use, gmic can synthesize images from scratch with no input (`gmic 64,64,1,3 fill_color ...`) — useful for procedural raster generation. The CLI can also output video frames or `.obj` 3D meshes, but image is the canonical kind.
