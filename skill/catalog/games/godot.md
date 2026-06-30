# Godot (GDScript)

slug: `godot` · category: `games` · artifact kind: **video**

## Summary

Godot 4 is an open-source game engine driven by GDScript. For OOTA's deterministic, version-controllable model, the **project source** is the authored artifact: `*.gd` scripts + `*.tscn`/`*.tres` text scenes/resources + `project.godot` (all plain-text, diffable, git-friendly). The deterministic renderable deliverable is produced via **Movie Maker mode**:

```
godot --path PROJECT --write-movie out.avi --fixed-fps 60 --quit-after N
```

`--fixed-fps` forces a constant delta (deterministic frame pacing) and `--quit-after N` stops after N frames. Output is either an MJPEG/AVI video (`.avi`) or a PNG image sequence + WAV (`.png`).

**CRITICAL CAVEAT:** Movie Maker needs a GPU rendering context. The `--headless` flag disables ALL rendering, so you **cannot** combine `--headless` with `--write-movie` — no frames are written. On macOS local (real GPU) this renders fine; in a display-less CI box you need GPU access or a virtual display.

Claude/Anthropic write GDScript reliably (low G3-vs-G4 syntax drift). Community Claude Code skills exist; no official Anthropic Godot skill.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| Randroids-Dojo/Godot-Claude-Skills | community | no | MIT | https://github.com/Randroids-Dojo/Godot-Claude-Skills |
| htdt/godogen | community | no | see repo | https://github.com/htdt/godogen |
| Godot Engine docs (CLI + Movie Maker) | reference | no | CC-BY 3.0 | https://docs.godotengine.org/en/stable/tutorials/animation/creating_movies.html |

- **Randroids-Dojo/Godot-Claude-Skills** — Randroids Dojo. Claude Code skill: develop/test/build/deploy Godot 4.x games; GdUnit4 testing, PlayGodot automation, web/desktop exports. Repo marked DEPRECATED, moved to Randroids Dojo marketplace.
- **htdt/godogen** — htdt. Autonomous game-dev pipeline for Godot 4 and Bevy using Claude Code skills as orchestration backbone; generates playable games from text descriptions.
- **Godot Engine official docs** — Godot Engine project. Authoritative reference for `--write-movie` / `--fixed-fps` and CLI export. Not a Claude skill but the canonical driving doc.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| GDScript (runs inside Godot 4 editor binary; not standalone) | `brew install --cask godot` — or download `Godot_v4.x-stable_macos.universal.zip` from godotengine.org. macOS binary lives inside the app: `Godot.app/Contents/MacOS/Godot` | Deterministic VIDEO render (needs GPU, NOT `--headless`): `Godot.app/Contents/MacOS/Godot --path PROJECT --write-movie out.avi --fixed-fps 60 --quit-after 300 --resolution 1280x720`. Headless export/logic: `Godot.app/Contents/MacOS/Godot --headless --path PROJECT --export-release ...` (rendering disabled). |

Output = MJPEG/AVI or PNG sequence + WAV (selected by `.avi` vs `.png` extension / MovieWriter project setting).

## Artifact kind

**video** — the primary deliverable is the Movie Maker render (AVI MJPEG or PNG image sequence + WAV).

## Validation

**Install:**
```bash
brew install --cask godot && /Applications/Godot.app/Contents/MacOS/Godot --version
```

**Smoke:**
```bash
mkdir -p /tmp/gdsmoke && cat > /tmp/gdsmoke/project.godot <<'EOF'
config_version=5
[application]
config/name="smoke"
run/main_scene="res://main.tscn"
[rendering]
renderer/rendering_method="gl_compatibility"
EOF
# main.gd + main.tscn ... then:
/Applications/Godot.app/Contents/MacOS/Godot --path /tmp/gdsmoke \
  --write-movie /tmp/gdsmoke/out.avi --fixed-fps 60 --quit-after 60 \
  --resolution 640x480 && ls -la /tmp/gdsmoke/out.avi
```

**Expect:** Godot opens the project, simulates 60 fixed-step frames, and writes a non-zero-byte `/tmp/gdsmoke/out.avi` (MJPEG). A brief render window / GPU context is used; do NOT add `--headless` or no frames are written. First run may import assets. Use a `.png` extension to get a deterministic PNG image sequence + `.wav`.

## Wrapper params

- `games.title` (text) — config/name in project.godot and on-screen label.
- `games.frames` (range) — `--quit-after` frame count.
- `games.fps` (range) — `--fixed-fps`.
- `games.resolution` (select) — e.g. 640x480 / 1280x720 / 1920x1080.

## Component / explorer notes

Authored artifact is a Godot project tree: `project.godot` (INI-ish text), `*.gd` (GDScript text), `*.tscn`/`*.tres` scenes/resources (text `format=3`) — all diffable and git-versionable. Determinism comes from `--fixed-fps` (constant delta, simulates as fast as possible) + `--quit-after N`. Avoid wall-clock time (`Time.get_ticks`/OS time), unseeded randomness (use a seeded `RandomNumberGenerator`), and physics jitter for fully reproducible renders. Renderer: `gl_compatibility` is most portable on macOS CI; `Forward+` uses Metal. Binary `.ctex`/`.import` caches are generated, not authored — add to `.gitignore`. Post-process AVI/PNG-seq to mp4 via ffmpeg if a standard container is needed.
