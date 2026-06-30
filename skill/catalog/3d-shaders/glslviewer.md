<!-- generated draft — needs validation -->
# glslViewer (3d-shaders)

## Summary
glslViewer is a console-based, BSD-3-Clause OpenGL sandbox by Patricio Gonzalez Vivo that loads GLSL frag/vertex shaders (plus images, OBJ/PLY/glTF geometry) and renders them. It supports true headless rendering to a PNG via `--headless -s <sec> -o out.png`, making shader output deterministic and version-controllable: the `.frag`/`.vert` source is the authored artifact, the PNG (or PNG sequence) is the deterministic deliverable. Primary OOTA kind is **image** (single PNG); a PNG sequence can be piped to ffmpeg for video. No official Anthropic/Claude skill exists; the canonical source is the upstream repo + wiki.

## Skills
| Name | Type | Official | URL | License | Attribution |
|------|------|----------|-----|---------|-------------|
| glslViewer Wiki — Using GlslViewer | community | no | https://github.com/patriciogonzalezvivo/glslViewer/wiki/Using-GlslViewer | BSD-3-Clause | Patricio Gonzalez Vivo (patriciogonzalezvivo/glslViewer) |
| glslViewer README | community | no | https://github.com/patriciogonzalezvivo/glslViewer/blob/main/README.md | BSD-3-Clause | Patricio Gonzalez Vivo |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| shell/CLI (native C++/OpenGL binary, pkg `glslViewer`) | `git clone --recursive https://github.com/patriciogonzalezvivo/glslViewer.git && brew install pkg-config cmake ncurses && cd glslViewer && mkdir build && cd build && cmake .. && make && sudo make install` | `glslViewer shader.frag -w 1024 -h 1024 --headless -s 1 -o out.png` |
| GLSL (authored source `.frag`/`.vert`; OpenGL desktop / WebGL via Emscripten) | n/a — author shader text consumed by the binary | uniforms `u_time` / `u_resolution` / `u_mouse` drive animation |

No official homebrew formula per upstream wiki — build from source.

## Artifact kind
**image** — a single PNG raster is the native deliverable. For motion, emit a deterministic PNG sequence (`--fps` / frame export) and hand to ffmpeg for video, but the native kind is image.

## Validation
- **install**: `git clone --recursive https://github.com/patriciogonzalezvivo/glslViewer.git && brew install pkg-config cmake ncurses && (cd glslViewer && mkdir -p build && cd build && cmake .. && make -j && sudo make install)`
- **smoke**: `printf 'void main(){ gl_FragColor = vec4(gl_FragCoord.xy/vec2(256.0), 0.5, 1.0); }' > /tmp/test.frag && glslViewer /tmp/test.frag -w 256 -h 256 --headless -s 1 -o /tmp/test.png && file /tmp/test.png`
- **expect**: `/tmp/test.png` exists and `file` reports `PNG image data, 256 x 256`. Process exits after ~1s with no window (headless). Note: headless GL on macOS may need an active GPU/display context; if it fails, run without `--headless` to confirm the binary, then retry.

## Wrapper params
- `3d-shaders.title` — text label, also stamped into the shader as a comment.
- `3d-shaders.width` / `3d-shaders.height` — output dimensions (`-w` / `-h`).
- `3d-shaders.time` — capture time in seconds (`-s`), pins `u_time` for determinism.

Wrap as a thin CLI shell-out: inputs = shader path + width/height + screenshot time + output path; output = PNG. Wrapper owns the contract (no official Anthropic skill).

## Component / explorer notes
Deliverable = a single PNG raster (image kind). Determinism holds when the shader avoids real-time/random seeds: pin `u_time` via `-s <fixed seconds>` and fixed `-w`/`-h` so identical source yields identical pixels. macOS-specific headless reliability not directly tested — confidence medium. CLI flags and BSD-3 license confirmed from upstream.
