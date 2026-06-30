# Shadertoy GLSL

slug: `shadertoy` · category: `3d-shaders` · artifact kind: **image**

## Summary

Shadertoy GLSL is a convention for single-file GLSL ES fragment shaders driven by
Shadertoy-style uniforms (`iResolution`, `iTime`, `iTimeDelta`, `iFrame`,
`iMouse`, `iDate`, `iChannel0-3`). The shader source is plain text —
deterministic and version-controllable. For OOTA, the cleanest headless path on
macOS is the **wgpu-shadertoy** Python library, which renders offscreen via wgpu
(Metal backend on macOS — no display/X server needed) and emits a PNG per frame
with a fixed `time_float`/`frame`, giving bit-stable output.

Primary deliverable is a single deterministic frame -> PNG (**image**). Video is
a secondary kind (sweep frames -> ffmpeg).

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| Shadertoy Shader Development | claude-skill | community | unspecified (community-listed) | https://mcpmarket.com/zh/tools/skills/shadertoy-shader-development |
| Shader Development Toolkit: GLSL & VFX | claude-skill | community | unspecified (community-listed) | https://mcpmarket.com/tools/skills/shader-development-toolkit |
| GLSL Shader Development | claude-skill | community | unspecified (community-listed) | https://mcpmarket.com/tools/skills/glsl-shader-development |
| glsl (claude-skills-generator) | claude-skill | community | see repo (github.com/martinholovsky/claude-skills-generator) | https://playbooks.com/skills/martinholovsky/claude-skills-generator/glsl |
| No official Anthropic shader skill | note | official | n/a | https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills |

Attribution: community skill listings (MCP Market, Playbooks) cover GLSL ES
syntax, ray marching, SDFs, procedural palettes using Shadertoy conventions. No
first-party Anthropic skill for Shadertoy/GLSL exists as of 2026-06.

## Toolchains

| Lang | Install | Invoke / Notes |
|------|---------|----------------|
| Python (primary) | `pip install wgpu-shadertoy pillow numpy` | `Shadertoy(code, resolution=(w,h), offscreen=True).snapshot(time_float=, frame=)` -> numpy -> PIL PNG. Headless via wgpu/Metal. BSD-2-Clause. https://github.com/pygfx/shadertoy |
| Python (video) | `git clone https://github.com/alexjc/shadertoy-render && pip install vispy numpy; brew install ffmpeg` | `python shadertoy-render.py example.glsl example.mp4` — pipes frames to ffmpeg. Needs an OpenGL context. |
| Go (video) | `go install codeberg.org/polyfloyd/shady/cmd/shady@latest; brew install ffmpeg` | `shady -i shader.glsl -ofmt rgb24 -framerate 60 \| ffmpeg ...`. Handles iTime/iFrame/iMouse/iResolution/iDate. |
| Python (video) | `git clone https://github.com/nabeel-oz/glsl-to-mp4; pip install -r requirements.txt; brew install ffmpeg` | Headless OpenGL 3.3 (moderngl), pipes raw pixels to ffmpeg H.264. Constant memory, seed-driven variation. |

## Artifact kind

**image** — one fixed-time frame rendered to PNG, fully reproducible. Animation
is the secondary video kind via frame sweep + ffmpeg.

## Validation

Install:

```bash
python3 -m venv /tmp/stv && /tmp/stv/bin/pip install wgpu-shadertoy pillow numpy
```

Smoke:

```bash
/tmp/stv/bin/python -c "from wgpu_shadertoy import Shadertoy; import numpy as np; from PIL import Image; code='void mainImage(out vec4 o, in vec2 fc){vec2 uv=fc/iResolution.xy; o=vec4(uv, 0.5+0.5*sin(iTime), 1.0);}'; s=Shadertoy(code, resolution=(640,360), offscreen=True); f=s.snapshot(time_float=1.0, frame=60); Image.fromarray(np.asarray(f)).save('/tmp/shadertoy_smoke.png'); print('ok')"
```

Expect: prints `ok` and writes `/tmp/shadertoy_smoke.png` — a 640x360 RGBA PNG
showing a uv gradient with a fixed blue level (deterministic for `time_float=1.0`).
Runs headless on macOS via wgpu's Metal backend (no window/display). Verify:
`test -s /tmp/shadertoy_smoke.png && file /tmp/shadertoy_smoke.png` (expect
`PNG image data, 640 x 360`).

## Wrapper params

- `shadertoy.title` — render label.
- `shadertoy.source` — the `.glsl`/`.frag` fragment shader (bound to `src/shader.glsl`).
- `shadertoy.width`, `shadertoy.height` — resolution.
- `shadertoy.time` — pinned `iTime` (float) for deterministic single-frame render.
- `shadertoy.frame` — pinned `iFrame` (int).

## Component / explorer notes

A Shadertoy deliverable is a single GLSL ES fragment shader implementing
`void mainImage(out vec4 fragColor, in vec2 fragCoord)`. The contract is the
Shadertoy uniform set: `iResolution` (vec3), `iTime` (float), `iTimeDelta`,
`iFrame` (int), `iMouse` (vec4), `iDate` (vec4), `iChannel0-3` (samplers for
multi-pass/textures). Multi-buffer shaders (Buffer A-D + Image) need FBO support
(danilw/scrygl shadertoy-to-video-with-FBO, or `shady`).

Determinism: pin `iTime`/`iFrame` explicitly and avoid `iDate`/`iMouse` for
reproducible single-frame renders; `iDate` breaks determinism if used. Primary
OOTA kind is image (one fixed-time frame -> PNG, fully reproducible). On macOS,
wgpu uses Metal so no headless display hack is needed; the OpenGL-based tools
(shadertoy-render, glsl-to-mp4) may need an offscreen GL context. ffmpeg is the
only non-pip dependency for the video kind (`brew install ffmpeg`).
