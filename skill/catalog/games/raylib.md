<!-- generated draft — needs validation -->
# raylib (games)

## Summary
raylib is a simple zlib-licensed C99 library for videogames programming (graphics, input, audio, 2D/3D). For OOTA the deterministic deliverable is a single rendered frame: draw into a `RenderTexture` (offscreen FBO), pull it back with `LoadImageFromTexture`, and `ExportImage("out.png")`. Source is plain text files (C, or Python/Go/Rust drivers), fully version-controllable.

Headless caveat: raylib normally opens a GLFW window for a GL context. On macOS, run with `FLAG_WINDOW_HIDDEN` to render without a visible window while still using the desktop GL context (works in a logged-in desktop session, not a pure no-display CI box). For true no-display software rendering there is a `raylib-software` pip variant (CPU rasterizer), but macOS wheel availability is uncertain — hence medium confidence on fully headless CI on macOS.

## Skills
| Skill | Type | Official | License | Attribution | URL |
|---|---|---|---|---|---|
| BINDINGS.md (official binding registry) | docs | yes | zlib/libpng | raysan5/raylib — Ramon Santamaria | https://github.com/raysan5/raylib/blob/master/BINDINGS.md |
| raylib cheatsheet (full API reference) | docs | yes | zlib/libpng | raysan5/raylib | https://www.raylib.com/cheatsheet/cheatsheet.html |
| raylib examples (render-texture + textures-to-image) | docs | yes | zlib/libpng | raysan5/raylib | https://www.raylib.com/examples.html |
| raylib-python-cffi (pyray/raylib) docs | docs | community | EPL-2.0 | electronstudio (Richard Smith) | https://electronstudio.github.io/raylib-python-cffi/pyray.html |
| raylib-go-headless (offscreen render bindings) | repo | community | zlib | icodealot | https://github.com/icodealot/raylib-go-headless |

## Toolchains
| Lang | Install | Invoke / notes |
|---|---|---|
| C (native C99) | `brew install raylib` | `cc app.c -o app $(pkg-config --libs --cflags raylib) && ./app`. RenderTexture2D + ExportImage for headless PNG. Most stable, dep-light. |
| Python (CPython 3.9+) | `pip install raylib` (or `pip install raylib-software` for CPU renderer) | Do NOT `pip install pyray` separately — the `raylib` wheel exposes both `raylib` and pythonic `pyray`. Binary wheels for macOS arm64/x86_64; source fallback needs brew raylib dev libs. Lowest friction. |
| Go (1.21+, cgo) | `go get github.com/gen2brain/raylib-go/raylib` (needs Xcode CLT + `brew install pkg-config`) | cgo bindings link native raylib. `icodealot/raylib-go-headless` targets background rendering. |
| Rust (1.70+) | `cargo add raylib` | deltaphc/raylib-rs (raylib 5.5). Builds raylib from source via `cc` (needs cmake + C toolchain). Idiomatic safe wrapper. |

## Artifact kind
**image** — the atomic deterministic unit is one rendered PNG frame. raylib can also export GIF / numbered frame sequences and you can stitch frames to video, but the single frame is the contract here.

## Validation
- **install:** `pip install raylib`
- **smoke:**
  ```bash
  python3 -c "from pyray import *; set_config_flags(ConfigFlags.FLAG_WINDOW_HIDDEN); init_window(320,240,'h'); t=load_render_texture(320,240); begin_texture_mode(t); clear_background(RAYWHITE); draw_circle(160,120,80,RED); draw_text('OOTA',110,110,20,BLACK); end_texture_mode(); img=load_image_from_texture(t.texture); image_flip_vertical(img); export_image(img,'out.png'); close_window()"
  ```
- **expect:** Exits 0 and writes `out.png` (320x240 PNG, red circle on white with 'OOTA' text). Verify: `test -f out.png && python3 -c "from PIL import Image; print(Image.open('out.png').size)"` → `(320, 240)`. RenderTexture FBOs are y-flipped, hence `image_flip_vertical`. `FLAG_WINDOW_HIDDEN` avoids a visible window but still needs a desktop GL context on macOS; for no-display CI use `pip install raylib-software`.

## Wrapper params
- `games.title` (text) — text drawn into the frame.

## Component / explorer notes
Deterministic single-frame pattern: `init_window` with `FLAG_WINDOW_HIDDEN` → `LoadRenderTexture(w,h)` → `BeginTextureMode`/`EndTextureMode` to draw → `LoadImageFromTexture` → `ImageFlipVertical` (FBO origin is bottom-left) → `ExportImage(png)`. Determinism is good for static scenes (no RNG, no real-time delta-time loop). For animation, drive a fixed frame counter and export numbered PNGs, then stitch with ffmpeg for a video kind. Avoid `GetFrameTime()`-driven physics if reproducibility matters — step with a fixed dt.

Wrapper guidance: pick one driver lang (Python/pyray = lowest friction, pip-only, no compile). Force `FLAG_WINDOW_HIDDEN`, always `ImageFlipVertical` after `LoadImageFromTexture`. For guaranteed no-GPU/no-display envs, target the `raylib-software` CPU backend or fall back to a Linux render container. zlib license is permissive and redistribution-friendly.
