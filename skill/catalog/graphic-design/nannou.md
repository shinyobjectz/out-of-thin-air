<!-- generated draft — needs validation -->
# nannou (graphic-design)

## Summary
Nannou is an open-source creative-coding framework for Rust (Processing/openFrameworks lineage), built on wgpu and — as of the 0.19.x line (0.19.0, 2025-11-16) — re-architected on top of the Bevy game engine, exposing its crates as Bevy plugins. It drives graphics, audio, lasers, lighting, multi-window and GUI from deterministic Rust code. For OOTA the deterministic deliverable is a rendered raster image (or frame sequence): a sketch/app calls `window.capture_frame(path)` to emit PNG/JPEG/TIFF/BMP/GIF/WebP. Because it is GPU/window-backed (winit + wgpu/Metal on macOS), truly headless rendering is not first-class — capture relies on a swapchain frame and normally needs a display/window context, lowering confidence for fully headless CI on macOS.

## Skills
- No official or community Claude/Agent skill found. No `SKILL.md`, `llms.txt`, or curated agent-skill repo for nannou as of 2026-06.
- Authoritative context: official guide https://guide.nannou.cc and in-repo examples https://github.com/nannou-org/nannou/tree/master/examples
- Attribution: nannou-org. License: MIT OR Apache-2.0.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Rust (native, stable) | `rustup toolchain install stable; cargo new sketch && cd sketch; cargo add nannou` (latest 0.19.x) | `cargo run --release` |

Notes: On macOS no extra system deps for graphics; audio/laser features pull extra crates only when enabled. Built on wgpu (Metal backend on macOS) and winit. Examples: `examples/draw/draw_capture.rs`, `examples/draw/draw_capture_hi_res.rs`.

## Artifact kind
**image** — PNG and other raster formats via `window.capture_frame` (png/jpeg/tiff/bmp/gif/webp). Frame-sequence capture is the path to video, but nannou does not mux video; render a numbered PNG sequence and hand off to ffmpeg. SVG/vector output is NOT a native target — nannou is a raster/GPU framework. Same Rust code + seeded randomness produces identical pixels, so source is version-controllable.

## Validation
- Install: `rustup toolchain install stable && cargo new nannou_smoke && cd nannou_smoke && cargo add nannou`
- Smoke (`src/main.rs`):
  ```rust
  use nannou::prelude::*;
  fn main(){ nannou::sketch(view).size(512,512).run(); }
  fn view(app:&App, frame:Frame){
      let draw=app.draw();
      draw.background().color(BLACK);
      draw.ellipse().x_y(0.0,0.0).radius(120.0).color(STEELBLUE);
      draw.to_frame(app,&frame).unwrap();
      let path=app.project_path().unwrap().join("out.png");
      app.main_window().capture_frame(path);
  }
  ```
  Run: `cargo run --release`
- Expect: a 512x512 `out.png` (black background, blue circle) written under the project dir. NOTE: nannou opens a winit window and renders via wgpu/Metal, so on macOS this needs a window/display context — not guaranteed to run truly headless in a no-display CI runner. A window may flash on a normal desktop session.

## Wrapper params
- `graphic-design.title` (text) — caption/identity for the sketch.
- `graphic-design.size` (text) — square render dimension in px (default 512).
- `graphic-design.bg` (color) — background fill.
- `graphic-design.fg` (color) — primary shape color.

## Component / explorer notes
Primary OOTA artifact = image. For hi-res, follow `examples/draw/draw_capture_hi_res.rs` (render to a larger texture). Caveat for headless macOS automation: no documented offscreen-only render path; known issues where `capture_frame` can fail under certain LoopModes (GitHub #525, #830). Recommend a real desktop session (or virtual display) and verifying the file lands. For video deliverables, emit a PNG frame sequence and post-process with ffmpeg.
