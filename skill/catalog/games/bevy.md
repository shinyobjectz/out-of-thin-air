<!-- generated draft — needs validation -->
# bevy (games)

## Summary
Bevy is a free, open-source, data-driven game engine built in Rust around an Entity Component System (ECS) architecture. It ships breaking releases roughly every ~3 months (recent versions in the 0.17/0.18/0.19 range across 2025-2026). Game code is plain Rust/Cargo source — there is no separate scripting or markup language as the primary authoring surface; scenes, systems, and the render pipeline are all authored as Rust and compiled with `cargo`. For OOTA's deterministic, headless, version-controllable model, the canonical headless deliverable is a single rendered frame saved as a PNG **image**. Bevy's official `examples/app/headless_renderer.rs` demonstrates exactly this: a camera renders to a GPU image render target, an `ImageCopyDriver` render-graph node copies the GPU image to a CPU buffer, the buffer is sent over a crossbeam channel to the main world, and the main world writes a PNG — with `WinitPlugin` disabled and `ScheduleRunnerPlugin` driving frames, so it runs fully headless (no window/display server). On macOS the image path uses the Metal/wgpu backend with no extra system deps. Multi-frame capture can produce video (assemble sequential PNGs with ffmpeg), but single-frame PNG is the simplest deterministic kind. No official Anthropic/Claude skill or llms.txt exists for Bevy.

## Skills
| Skill | Type | Official | Attribution | License | URL |
|---|---|---|---|---|---|
| bevy-game-engine (Bevy ECS development) | community skill | no | Lauri Gates (laurigates/claude-plugins) — idiomatic ECS patterns, system ordering/scheduling, state management, multi-device input, 2D/3D render pipeline config | MIT | https://github.com/laurigates/claude-plugins/blob/main/bevy-plugin/skills/bevy-game-engine/skill.md |
| Official Bevy docs / examples | official-docs + source | yes | Bevy Engine project — engine source + official examples incl. examples/app/headless_renderer.rs (headless PNG output) | MIT OR Apache-2.0 | https://github.com/bevyengine/bevy |

No Anthropic skill or llms.txt found. Authoritative references for an OOTA wrapper are the official repo/examples (https://github.com/bevyengine/bevy), docs at https://bevy.org and https://docs.rs/bevy. Other community Claude skills exist as marketplace listings (mcpmarket.com, claudemarketplaces.com bfollington/terma) without clear licensing — the laurigates skill is the most concrete with a real repo URL and stated MIT license.

## Toolchains
| lang | install | invoke |
|---|---|---|
| Rust (native, compiled binary) | Install Rust via rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh && source $HOME/.cargo/env`. New project: `cargo new mygame && cd mygame && cargo add bevy`. macOS needs no extra system deps for the headless image path (wgpu Metal backend). | Build/run with `cargo run`. Run the bundled headless example from a clone of the bevy repo: `cargo run --example headless_renderer`. Game logic, scenes, and render pipeline are all authored as Rust source — there is no separate scripting language. |

## Artifact kind
**image** — the canonical headless deliverable is a rendered PNG frame. The mechanism is the official `examples/app/headless_renderer.rs`: camera → GPU image render target → `ImageCopyDriver` render-graph node copies GPU→CPU buffer → crossbeam channel → main world saves PNG. `WinitPlugin` disabled and `ScheduleRunnerPlugin` drives frames, so it runs with no display server. The deterministic, version-controllable input is the Rust scene source. Multi-frame output (sequential PNGs assembled by ffmpeg) yields video, but single-frame PNG is the simplest deterministic kind.

## Validation
- **install**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source $HOME/.cargo/env` then `git clone --depth 1 https://github.com/bevyengine/bevy && cd bevy`
- **smoke**: `cargo run --example headless_renderer` — disables `WinitPlugin` and uses `ScheduleRunnerPlugin` so no window/display is opened; renders ~40 pre-roll frames then writes one PNG and exits.
- **expect**: a PNG file is written to `./test_images/000.png` (a rendered frame of the scene) with no window appearing on screen — confirming headless image output on macOS via the Metal/wgpu backend. Build times are significant (Rust + large engine); cache `target/`.

## Wrapper params
- `games.title` — project / scene name (Cargo package name).
- `games.bevy_version` — pinned bevy crate version in Cargo.toml (Bevy ships breaking API changes every ~3 months, so pin it).
- `games.width` / `games.height` — render target dimensions in pixels.
- `games.source` — the Rust scene source (textarea bound to `src/main.rs`).

## Component / explorer notes
Bevy's primary OOTA deliverable is a rendered PNG image. The deterministic, version-controllable artifact is the **scene definition (Rust source)** — fully reproducible. Determinism caveat: GPU rasterization output can vary slightly across drivers/hardware, so pixel-exact reproducibility across machines is **not** guaranteed even though the scene source is deterministic. A wrapper should scaffold a Cargo project, vendor or template the headless_renderer pattern (camera → GPU image → CPU buffer → channel → PNG save, `WinitPlugin` disabled, `ScheduleRunnerPlugin`), and invoke via `cargo run`. Pin the bevy crate version in Cargo.toml. Build times are large (Rust + engine); cache the `target/` dir. macOS uses Metal via wgpu — no X server needed, genuinely headless. For video, save sequential PNGs and assemble with `ffmpeg`.
