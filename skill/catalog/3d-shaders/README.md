# 3d-shaders

Declarative/scripted 3D scenes and pure shader source → image / video / model3d. Author a scene (`.py`, `.usda`, `.pov`) or a shader (`.frag`/`.glsl`) as diff-friendly text; render headless to a raster artifact.

## BUILD MATRIX

| tool | kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [Blender (bpy)](./blender.md) | image | Python / bundled CPython (app mode); Python / standalone CPython + bpy (PyPI) | Blender Python API Reference (official docs) | no | ok | yes | yes |
| [OpenUSD (usdrecord)](./openusd.md) | image | shell/CLI usdrecord (full build w/ imaging); python usd-core (authoring only); c++ libusd (embed Hydra) | OpenUSD official toolset docs | no | ok | yes | yes |
| [glslViewer](./glslviewer.md) | image | shell/CLI (native C++/OpenGL); GLSL source (.frag/.vert) | glslViewer Wiki — Using GlslViewer | no | ok | yes | yes |
| [Shadertoy GLSL](./shadertoy.md) | image | python wgpu-shadertoy; python shadertoy-render; go shady; python glsl-to-mp4 | Shadertoy Shader Development | no | ok | yes | yes |
| [POV-Ray](./povray.md) | image | POV-Ray SDL (native CLI); shell (povray CLI); python (vapory) | POV-Ray official docs + vapory | no | ok | yes | yes |

All five emit `image` (raster PNG). All source forms (.py / .usda / .frag / .glsl / .pov) are deterministic, diff-friendly text. No official Anthropic/Claude skill exists for any tool in this category — primaries are upstream docs/wikis.

## Multi-toolchain notes

- **Blender** — App mode (`blender -b --factory-startup --python script.py`) is the robust/recommended contract. Module-mode `bpy` (PyPI wheel) is brittle: the standalone CPython minor version must exactly match the wheel.
- **OpenUSD** — CRITICAL: `pip install usd-core` is **authoring-only** and ships **no `usdrecord` binary**. Rendering requires a full `build_usd.py` (imaging + Hydra) or a prebuilt distribution. macOS renders offscreen via Storm/Metal (no X server needed).
- **glslViewer** — Native binary built from source (`cmake`/`make`); `--headless -o out.png` for offscreen render. macOS headless may still need a GPU/display context.
- **Shadertoy** — Primary path `wgpu-shadertoy` (Metal headless on macOS, deterministic `snapshot`). Alternatives (shadertoy-render, go shady, glsl-to-mp4) target video.
- **POV-Ray** — Fully headless CPU raytrace (`-D` disables display); deterministic bytes. `vapory` is a thin Python binding over the same CLI.

## VALIDATION ORDER

Cheapest/most-reliable installs first:

1. **POV-Ray** — `brew install povray`. Single formula, pure-CPU deterministic raytrace, fully headless (`-D`). Most reliable smoke.
2. **Shadertoy** — `pip install wgpu-shadertoy pillow numpy` in a venv. Metal headless, deterministic snapshot, no system build.
3. **Blender** — `brew install --cask blender`. One command; large download but app-mode render is robust.
4. **glslViewer** — source build (git clone + cmake + make + install). Heavier; headless GPU context can fail on macOS CI.
5. **OpenUSD** — full `build_usd.py` (imaging + Hydra), multi-hour compile. Heaviest; pip path cannot render.

## EXPLORER NEEDS

- **Shadertoy, glslViewer** — want a live shader-editor explorer (textarea bound to `.frag`/`.glsl` + hot-reload preview + width/height/time controls); default shell is workable but underserves iteration.
- **Blender, OpenUSD** — would benefit from a 3D-viewport explorer (camera/scene inspection); default shell is adequate for scripted renders.
- **POV-Ray** — default shell sufficient (SDL text → PNG, no interactive surface needed).
