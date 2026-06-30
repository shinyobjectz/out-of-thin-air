<!-- generated draft — needs validation -->
# manim (video)

## Summary
Manim is a Python framework for programmatic, frame-accurate motion graphics — math and explanatory animations in the 3Blue1Brown style. You author `Scene` subclasses in Python and the CLI renders deterministic MP4 (or PNG stills, GIF, transparent MOV). Two living forks exist: **ManimCommunity/manim** (ManimCE — recommended, actively maintained, MIT) and **3b1b/manim** (manimgl — Grant Sanderson's original OpenGL build). Python is the only driver language; there is no native Go/JS/Rust binding. The APIs of the two forks are **not** interchangeable. Primary deliverable is a video file (`.mp4`).

## Skills
| Skill / doc | Type | URL | Official | License |
|---|---|---|---|---|
| Yusuke710/manim-skill | repo | https://github.com/Yusuke710/manim-skill | community | see repo |
| adithya-s-k/manim_skill | repo | https://github.com/adithya-s-k/manim_skill | community | see repo |
| johnlarkin1/claude-code-extensions (manim skill) | repo | https://playbooks.com/skills/johnlarkin1/claude-code-extensions/manim | community | see repo |
| Manim Community official docs | official-docs | https://docs.manim.community/en/stable/ | official | MIT (docs CC) |

Attribution: ManimCE by the Manim Community; manimgl by Grant Sanderson (3Blue1Brown). Community skills credited to Yusuke710, adithya-s-k, and johnlarkin1 respectively.

## Toolchains
| lang | install | invoke |
|---|---|---|
| Python (ManimCE) — PRIMARY, authors + renders locally | `pip install manim` (also needs ffmpeg; macOS: `brew install ffmpeg`) | `manim -ql scene.py SceneName` |
| Python (manimgl / 3b1b) — original OpenGL fork, NOT API-compatible | `pip install manimgl` (plus ffmpeg, LaTeX for tex) | `manimgl scene.py SceneName` |

Notes:
- ManimCE is the recommended fork; Cairo/Pango ship in the wheels, only ffmpeg is an external dep.
- LaTeX (a TeX distribution) is required for `Tex`/`MathTex` mobjects in either fork.
- The two forks share class names but differ in API — code is not portable between them.

## Artifact kind
`video` — the universal shell plays the rendered `.mp4` directly with a `<video>` tag. PNG stills (`-s`) fall back to the `image` kind.

## Validation
- **install**: `pip install manim && (command -v ffmpeg || brew install ffmpeg)`
- **smoke**: `printf 'from manim import *\nclass S(Scene):\n    def construct(self):\n        self.play(Create(Circle()))\n' > /tmp/s.py && manim -ql -o out /tmp/s.py S`
- **expect**: Renders headless (no GUI needed) to `media/videos/s/480p15/out.mp4` — a short MP4 of a circle being drawn. Exit 0 and `File ready at ...mp4` logged. `-ql` is fast low-quality; `-qh` is 1080p60.

## Wrapper params
Worth exposing on a render wrapper:
- positional scene-class selector (which `Scene` to render)
- `-q` quality (`l`/`m`/`h`/`p`/`k` = 480p15 → 4k60)
- `-r WxH` resolution and `--fps`
- `-s` (save last frame as PNG still)
- `-t` (transparent background → MOV/PNG)
- `-a` (render all scenes in the file)
- `--format` (mp4/gif/png/mov)
- `-o` output name
- Render is deterministic given seed/code — good for data-driven pipelines.

## Component / explorer notes
Primary output is a standard H.264 `.mp4` — the default video artifact shell plays it with a `<video>` tag; no richer explorer is needed. PNG stills (`-s`) fall back to the image kind. The interactive OpenGL preview window (`--preview`) requires a display and is **not** headless-friendly, so it is out of scope for the render pipeline.
