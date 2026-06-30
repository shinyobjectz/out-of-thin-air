<!-- generated draft — needs validation -->
# OpenUSD (usdrecord) — 3d-shaders

## Summary
`usdrecord` is OpenUSD's command-line headless renderer. It takes a USD stage
(`.usda`/`.usdc`/`.usdz` — deterministic, version-controllable scene markup) and
renders it via Hydra to a PNG image (or per-frame image sequence) using the Storm
render delegate by default (Metal on macOS). Authoring the scene is fully
deterministic text (`.usda` is human-readable ASCII USD); `usdrecord` turns it into
a pixel deliverable headlessly.

**CRITICAL CAVEAT:** the pip `usd-core` package ships ONLY the core non-imaging
libraries and does NOT include `usdrecord`, `usdview`, or Hydra/Storm — there is no
`usdrecord` binary after `pip install usd-core`. To get `usdrecord` you need a full
OpenUSD build with imaging enabled (`build_usd.py`) or NVIDIA's prebuilt
distribution. This is why confidence is medium: the easy install path does not yield
the renderer.

## Skills
- **No OpenUSD-specific Claude/Anthropic skill exists** (none, community).
  https://github.com/anthropics/skills — searched; contains document skills
  (pdf/docx/xlsx/pptx) and claude-api only; no USD/3D skill. License: n/a.
- **OpenUSD official toolset docs** (docs, official) — authoritative reference for
  `usdrecord`, used in lieu of a skill.
  https://openusd.org/release/toolset.html — Pixar Animation Studios / Alliance for
  OpenUSD (AOUSD). License: Apache-2.0 (modified, TOST).
- **NVIDIA Learn OpenUSD** (docs, community/vendor) — install + Python authoring
  tutorials.
  https://docs.nvidia.com/learn-openusd/latest/usdview-install-instructions.html —
  NVIDIA. License: vendor docs.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| shell/CLI | `git clone https://github.com/PixarAnimationStudios/OpenUSD && python OpenUSD/build_scripts/build_usd.py /opt/openusd` (Xcode CLT + cmake; ~30-60min). pip `usd-core` does NOT provide usdrecord | `usdrecord scene.usda out.png` (after PATH/PYTHONPATH set from build). Flags: `--imageWidth --camera --frames --renderer Storm\|Embree --complexity --colorCorrectionMode --disableGpu` |
| python | `pip install usd-core` (authoring ONLY — Usd/Sdf/Gf/UsdGeom/UsdShade; no imaging) | `python -c "from pxr import Usd, UsdGeom; ..."` to author `.usda` programmatically; hand stage to a full-build usdrecord to render |
| c++ | same `build_usd.py`; links `libusd_*` + Hydra | embed Hydra rendering directly instead of shelling out (optional) |

## Artifact kind
**image** — primary deliverable is a single PNG. `--frames` emits a numbered PNG
sequence (mux to video downstream with ffmpeg if a video kind is wanted).

## Validation
**install**
```bash
python OpenUSD/build_scripts/build_usd.py --no-tests /opt/openusd
export PATH=/opt/openusd/bin:$PATH
export PYTHONPATH=/opt/openusd/lib/python:$PYTHONPATH
```
**smoke**
```bash
cat > /tmp/cube.usda <<'EOF'
#usda 1.0
(
  upAxis = "Y"
  defaultPrim = "World"
)
def Xform "World" {
  def Cube "cube" { double size = 2 }
  def DistantLight "sun" { float inputs:intensity = 2 }
}
EOF
usdrecord --imageWidth 512 /tmp/cube.usda /tmp/cube.png && file /tmp/cube.png
```
**expect** — `/tmp/cube.png` written as a 512px-wide PNG (Storm/Metal render of the
cube); `file` reports `PNG image data`. On macOS Storm uses Metal so no X server /
Qt-headless workaround is needed (the documented headless Qt/GLFW issue is primarily
a Linux concern). Determinism: same `.usda` + same flags ⇒ byte-stable-ish PNG
(Storm raster; raytracers like Embree may have minor sampling variance).

## Wrapper params
First-class knobs: `--imageWidth`, `--camera`, `--frames`, `--renderer`,
`--complexity`. Wrapper must NOT rely on `pip install usd-core` for the render step —
that package omits `usdrecord`. Two-tier setup: (1) `usd-core` for fast Python scene
authoring in any venv; (2) a full OpenUSD build (`build_usd.py` with imaging+Hydra)
OR a vendored prebuilt for the render binary. Pin the OpenUSD version (e.g. v25.02 /
26.x) and surface the resolved `usdrecord` path + renderer. Validate `which usdrecord`
before claiming render capability.

## Component / explorer notes
The source artifact OOTA authors and version-controls is the `.usda` (ASCII USD)
scene — fully diffable text. `.usdc` is the binary-crate equivalent (smaller, not
diff-friendly); prefer `.usda` in repos. Storm raster output is deterministic enough
for visual regression; switch `--renderer Embree`/RenderMan for path-traced
EXR-quality but with sampling noise. Detect headless context: macOS Storm works
offscreen via Metal; only Linux needs EGL/GLFW shims.
