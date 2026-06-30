<!-- generated draft — needs validation -->
# pyxel (games)

## Summary
Pyxel is an open-source (MIT) retro game engine for Python by Takashi Kitao (kitao). A Rust core with Python bindings, deliberately constrained to a 16-color palette and 4 sound channels for pixel-art / chiptune games. Games are authored as deterministic, version-controllable Python source driven by `pyxel.init(w, h)` and `pyxel.run(update, draw)`. The renderable OOTA deliverable is a gameplay capture: Pyxel ships built-in, code-callable capture APIs — `pyxel.screenshot()` (PNG) and `pyxel.screencast()` (animated GIF) — plus interactive hotkeys Alt+1 (screenshot), Alt+2 (reset capture start), Alt+3 (save GIF, up to 30s). `pyxel.init()` takes `capture_scale` and `capture_sec` to size the rolling capture buffer. Primary OOTA kind = **video** (GIF gameplay capture via `screencast`); **image** (PNG via `screenshot`) is the secondary single-frame deliverable. Determinism: subprocess isolation gives fresh state per run; seed any RNG for reproducible frames. Current version 2.x (>=2.9.6 as of mid-2025).

**Headless caveat:** Pyxel renders via SDL2 and normally opens a native window. True headless capture is the design goal of the official `pyxel-mcp` server, which runs N frames in subprocess isolation and emits PNG snapshots without a visible window. On macOS there is no Xvfb (X11-only); headless reliability depends on the SDL offscreen/dummy video driver and is not guaranteed — hence **medium** confidence.

## Skills
| Skill | Type | Official | License | Attribution | URL |
|---|---|---|---|---|---|
| pyxel-mcp (MCP server) | mcp-server | yes | MIT | Takashi Kitao (kitao), Pyxel author | https://github.com/kitao/pyxel-mcp |
| Pyxel User Guide / API Reference | docs | yes | MIT | Takashi Kitao (kitao) | https://kitao.github.io/pyxel/web/api-reference/ |
| Pyxel repository + examples | examples | yes | MIT | Takashi Kitao (kitao) | https://github.com/kitao/pyxel |

## Toolchains
| lang | install | invoke |
|---|---|---|
| Python (CPython 3.8+) | `pip install pyxel` (or `uv pip install pyxel`) | `pyxel run game.py` or `python game.py`; code entry `pyxel.init(w,h,capture_scale=,capture_sec=)` + `pyxel.run(update,draw)`; capture via `pyxel.screenshot()` / `pyxel.screencast()`. Other CLI verbs: `pyxel play/edit/package/app2html/watch`. |
| Python (headless / agentic) | `uvx pyxel-mcp` (auto-installs pyxel>=2.9.6) | Official MCP server: headless, deterministic, subprocess-isolated. Tools: `run` (execute N frames headlessly with input → PNG snapshot), `validate`, `diff_frames` (pixel-diff two PNGs), `read_*` (palette/image/anim/tilemap/audio), `pyxel_info`. Recommended path for deterministic headless rendering. |

Note: the Rust core powers the engine but is distributed only as the Python wheel — there is no separate published Rust user crate for authoring games.

## Artifact kind
**video** — the primary deliverable is an animated GIF gameplay capture via `pyxel.screencast()`. Secondary fallback: single-frame PNG via `pyxel.screenshot()` (image).

## Validation
- **install:** `pip install pyxel`
- **smoke:** Deterministic frame-to-file (headless-leaning). Create `smoke.py`:
  ```python
  import pyxel
  pyxel.init(64, 64, capture_scale=2)
  frame = 0
  def update():
      global frame
      frame += 1
      if frame >= 3:
          pyxel.screenshot('out')   # writes out.png
          pyxel.quit()
  def draw():
      pyxel.cls(0)
      pyxel.rect(8, 8, 48, 48, 11)
      pyxel.text(16, 28, 'OOTA', 7)
  pyxel.run(update, draw)
  ```
  Run: `python smoke.py`. On macOS this opens a brief SDL window then exits, writing `out.png`. For genuinely windowless CI capture, prefer the official server: `uvx pyxel-mcp` and call its `run` tool with the same script + frame count to emit a PNG snapshot via subprocess isolation. Try `SDL_VIDEODRIVER=dummy python smoke.py` for offscreen, but verify the PNG still renders (the dummy driver may blank the framebuffer).
- **expect:** `out.png` exists, 128x128 px (64 * capture_scale), dark background with a blue rounded rect and white 'OOTA' text. For the GIF video deliverable, swap `pyxel.screenshot('out')` for `pyxel.screencast('out')` to emit `out.gif` of the captured rolling buffer.

## Wrapper params
- `games.title` — text drawn / window title
- `games.width` / `games.height` — `pyxel.init()` canvas dims
- `games.capture_scale` — output resolution multiplier
- `games.capture_sec` — GIF rolling-buffer length (seconds)
- `games.frames` — how many frames to run before capture + quit
- `games.main` — the Python game source (bound to `src/game.py`)

## Component / explorer notes
Pyxel is a stateful, frame-loop game engine, not a one-shot renderer. An OOTA component wraps a Python game module exposing init params + `update`/`draw` and a fixed capture trigger (run N frames, then `screenshot`/`screencast` + `quit`). Determinism requires seeding any RNG and avoiding wall-clock / input nondeterminism so a given source always yields identical frames. The palette is a fixed 16 colors; assets (`.pyxres`) are version-controllable binary editor files — prefer code-drawn graphics (`cls`/`rect`/`text`/`blt`) for pure text-diffable source. `capture_scale` controls output resolution; `capture_sec` sizes the GIF rolling buffer.

Two render paths: (1) plain Pyxel — reliable on a desktop session but opens an SDL2 window, so not cleanly headless on macOS (no Xvfb; `SDL_VIDEODRIVER=dummy` is unverified for framebuffer capture). (2) official `pyxel-mcp` `run` tool — purpose-built for headless, deterministic, subprocess-isolated frame capture to PNG; this is the recommended OOTA integration on macOS/CI. Primary artifact kind = video (GIF via `screencast`); image (PNG via `screenshot`) is the fallback. MIT licensed throughout. Confidence medium pending a macOS headless capture verification run.
