<!-- generated draft — needs validation -->
# Python Arcade (games)

## Summary
Python Arcade (slug `arcade`) is a Python 3 framework for 2D games built on pyglet/OpenGL. For OOTA's deterministic-render model, the relevant capability is its offscreen/headless framebuffer rendering: you draw to a framebuffer and dump it to a PNG via `arcade.get_image(...).save()`. Primary deliverable is **image** (PNG); video is achievable by rendering a deterministic numbered frame sequence and piping through ffmpeg, but Arcade has no built-in video encoder.

CRITICAL CAVEAT for OOTA: the documented headless path requires Linux with EGL. Setting `os.environ['ARCADE_HEADLESS']='true'` before `import arcade` extends pyglet's headless EGL window and is explicitly Linux/server/VM only. macOS has no EGL headless backend, so a truly headless smoke test on macOS is not supported out of the box; on macOS you must open a real (visible) GL window backed by a display, which is not deterministic-headless. This is why confidence is **low** for the macOS-headless requirement — OOTA should target a Linux container for headless determinism and treat macOS as dev-only with a visible window. No official Anthropic/Claude skill exists for Arcade.

## Skills
| Skill | Type | Official | License | Attribution | URL |
|---|---|---|---|---|---|
| Python Arcade documentation (Headless guide) | docs | yes | MIT (project) | The Python Arcade Library, api.arcade.academy | https://api.arcade.academy/en/latest/programming_guide/headless.html |
| pythonarcade/arcade source repo | repo | yes | MIT | Paul Vincent Craven & Arcade contributors | https://github.com/pythonarcade/arcade |
| arcade on PyPI | package | yes | MIT | Python Arcade maintainers | https://pypi.org/project/arcade/ |

## Toolchains
| Lang | Install | Invoke / notes |
|---|---|---|
| Python (CPython 3.9+; arcade 3.3.x line) | `python3 -m venv venv && source venv/bin/activate && pip install arcade` | Single supported driving language — Arcade is Python-only. Invoke a render script with `python script.py`. Built on pyglet + pymunk + Pillow + PyOpenGL. Pillow is a dependency so `arcade.get_image()` returns a PIL Image you can `.save('out.png')`. Headless (`ARCADE_HEADLESS=true`) needs Linux + EGL/libegl; on macOS only windowed GL rendering is available. Pin `arcade==3.3.x` for API stability. |

## Artifact kind
**image** — the atomic deterministic unit is one rendered PNG frame via `arcade.get_image().save()`. For animation/video, render N numbered PNG frames then stitch with ffmpeg (`ffmpeg -framerate 30 -i frame_%04d.png out.mp4`) — Arcade has no native encoder.

## Validation
- **install:** `python3 -m venv /tmp/arc && source /tmp/arc/bin/activate && pip install arcade`
- **smoke** (Linux/EGL — recommended OOTA target):
  ```bash
  ARCADE_HEADLESS=true python -c "import os; os.environ['ARCADE_HEADLESS']='true'; import arcade; w=arcade.open_window(100,100); arcade.draw_rect_filled(arcade.rect.XYWH(50,50,50,50),arcade.color.AMAZON); arcade.get_image(0,0,*w.get_size()).save('framebuffer.png')"
  ```
  On macOS this headless path FAILS (no EGL); a windowed fallback requires an active display/GL context and is not deterministic-headless.
- **expect:** On Linux+EGL, a 100x100 `framebuffer.png` is written with an Amazon-green square. On macOS headless: errors out (no EGL backend) — macOS cannot satisfy the headless smoke as documented.

## Wrapper params
- `games.title` (text) — label intent for the rendered frame (drawing text is optional in the minimal scene).

## Component / explorer notes
Deliverable is a rasterized PNG image (or a sequence of PNGs for animation/video). Rendering is deterministic only if the script avoids real-time clocks and randomness — drive frames by an explicit frame counter, fixed seed, and fixed dt rather than wall-clock `on_update` timing.

API churn note: older docs use `arcade.draw_rectangle_filled(...)` (3.0-) while 3.3.x deprecates it in favor of `arcade.draw_rect_filled(arcade.rect.XYWH(...))` — pin the arcade version in the component to keep render code stable.

Wrapper pattern for OOTA: a Python render script that (1) sets `ARCADE_HEADLESS` before `import arcade`, (2) opens a fixed-size window, (3) draws deterministically, (4) emits PNG(s) via `arcade.get_image().save()`. macOS headless is the key risk: the documented headless backend is Linux/EGL only, so target a Linux container for headless determinism. MIT license is permissive and redistribution-friendly.
