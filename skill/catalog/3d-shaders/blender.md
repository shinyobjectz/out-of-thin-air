<!-- generated draft — needs validation -->
# Blender (bpy) — 3d-shaders

## Summary
Blender's `bpy` is the Python API of Blender, the open-source 3D suite. A `.py` script deterministically builds a scene (geometry, materials/shaders via the node graph, camera, lights), then renders headlessly with the Cycles or EEVEE engine to an image (or animation/video, or exports a model3d). Two drive modes: (1) the full Blender app run with `blender --background --python script.py`, and (2) `bpy` installed as a standalone pip module (`import bpy`) for any CPython script. Both run headless on macOS. Scripts are plain text, fully version-controllable; renders are reproducible given fixed seed/sample counts. Latest standalone bpy on PyPI is 5.1.2 (May 2026); each bpy version pins exactly one CPython version.

For the 3d-shaders category, the load-bearing artifact is the shader/material node graph evaluated into a rendered image.

## Skills
| Name | Type | Official | URL | Attribution | License |
|------|------|----------|-----|-------------|---------|
| No official Anthropic/Claude Blender skill found | skill | no | https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview | Anthropic | n/a |
| Blender Python API Reference (official docs) | docs | yes | https://docs.blender.org/api/current/ | Blender Foundation | GPL / docs CC |
| Blender as a Python Module (official build handbook) | docs | yes | https://developer.blender.org/docs/handbook/building_blender/python_module/ | Blender Foundation | GPL-2.0+ |
| blenderless — community headless-render Python wrapper | community-repo | no | https://github.com/oqton/blenderless | Oqton | MIT |

## Toolchains
| Lang | Runtime | Install | Invoke |
|------|---------|---------|--------|
| Python | Blender bundled CPython (app mode) | `brew install --cask blender` (provides `/Applications/Blender.app/Contents/MacOS/Blender`) | `blender --background --python script.py [-- extra args]` |
| Python | standalone CPython matching the bpy build | `python3.11 -m venv .venv && .venv/bin/pip install bpy` (venv CPython minor must match the bpy wheel) | `python script.py` (script does `import bpy`) |

Notes:
- App mode uses Blender's interpreter; no standalone Python needed. Headless via `--background` (`-b`).
- Each bpy release pins ONE CPython minor (e.g. bpy 4.x ↔ 3.11, bpy 5.x ↔ 3.11/3.12). Mismatch => no install candidate.
- `bpy` can only be imported once per process — a long-running service must subprocess per render.

## Artifact kind
**image** — a rendered frame (PNG/EXR). Blender also natively produces **video** (FFmpeg container via `scene.render.image_settings` + frame range + `bpy.ops.render.render(animation=True)`) and **model3d** (export glTF/.glb via `bpy.ops.export_scene.gltf`).

## Validation
Install:
```bash
brew install --cask blender
```
Smoke:
```bash
cat > /tmp/smoke.py <<'PY'
import bpy
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.mesh.primitive_uv_sphere_add()
bpy.ops.object.light_add(type='SUN', location=(5,5,5))
bpy.ops.object.camera_add(location=(0,-6,2), rotation=(1.2,0,0))
bpy.context.scene.camera = bpy.context.object
sc = bpy.context.scene
sc.render.engine = 'BLENDER_EEVEE_NEXT'
sc.render.resolution_x = 320; sc.render.resolution_y = 240
sc.render.filepath = '/tmp/blender_smoke.png'
bpy.ops.render.render(write_still=True)
PY
/Applications/Blender.app/Contents/MacOS/Blender --background --factory-startup --python /tmp/smoke.py
ls -la /tmp/blender_smoke.png
```
Expect: Blender runs headless (no window), prints `Saved: /tmp/blender_smoke.png`, and a non-empty 320x240 PNG exists at `/tmp/blender_smoke.png`. EEVEE engine id is `BLENDER_EEVEE_NEXT` on 4.2+; use `CYCLES` for path-traced shaders.

## Wrapper params
- `3d-shaders.title` (text) — scene/output label.
- `3d-shaders.engine` (select: BLENDER_EEVEE_NEXT, CYCLES) — render engine; EEVEE fast/raster, Cycles path-traced.
- `3d-shaders.samples` (range) — Cycles sample count; fix for determinism.
- `3d-shaders.color` (color) — base shader color fed into the material node graph.
- `3d-shaders.resolution` (text) — `WxH`.

## Component / explorer notes
Primary deliverable is an image render. Determinism: fix the Cycles seed and sample count; EEVEE is rasterized and stable. GPU not required — CPU Cycles works headless on macOS but is slow; EEVEE is fast for previews. macOS headless caveat: Cycles GPU (Metal) may be unavailable under `--background`; default to CPU or EEVEE for CI. Output path is fully script-controlled (`scene.render.filepath`), so deterministic file emission is straightforward.

Two invocation contracts to expose:
- APP mode (recommended, most robust): `blender -b --factory-startup --python script.py` — `--factory-startup` so user prefs/addons don't perturb determinism; pass scene params after `--` and read via `sys.argv`.
- MODULE mode: `import bpy` in a venv whose CPython minor EXACTLY matches the bpy wheel (brittle; pin both).
