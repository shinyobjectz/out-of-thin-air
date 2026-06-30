<!-- generated draft — needs validation -->
# povray (3d-shaders)

## Summary
POV-Ray (Persistence of Vision Raytracer) is a free, open-source CPU ray tracer driven by its own deterministic Scene Description Language (SDL). You author a plain-text `.pov` file — camera, lights, geometry, CSG, textures, finishes/pigments/normals (its "shaders") — and render it headlessly to a raster image via the `povray` CLI. Output is byte-deterministic for a given scene + seed, the source is version-controllable text markup, and rendering runs fully headless on macOS. POV-Ray's "shaders" are SDL texture/finish/pigment/normal/media blocks plus a procedural pattern/function language (isosurfaces, pigment functions) — not GPU GLSL; it is a single-machine CPU ray tracer. Current stable: 3.7.0.10 (AGPL-3.0-or-later). No official Anthropic/Claude skill exists; POV-Ray is a strong fit for OOTA as a deterministic text-to-image tool. macOS install is via Homebrew (`brew install povray`) — the project ships official binaries only for Windows, but Homebrew packages the Unix/console build.

## Skills
| Skill | Type | Official | Attribution | License | URL |
|---|---|---|---|---|---|
| POV-Ray official documentation (SDL + CLI reference) | official-docs | no (docs, not an agent skill) | POV-Ray project | docs: POV-Ray project | https://www.povray.org/documentation/ |
| POV-Ray command-line options reference | official-docs | no | POV-Ray project | docs: POV-Ray project | https://www.povray.org/documentation/view/3.6.1/759/ |
| POV-Wiki | community-docs | no | POV-Ray community | wiki license per site | https://wiki.povray.org/ |
| POV-Ray source repo | source | no | POV-Ray project | AGPL-3.0-or-later | https://github.com/POV-Ray/povray |
| vapory (Python binding) | library-binding | no | Zulko (community) | MIT | https://github.com/Zulko/vapory |

No Anthropic skill or llms.txt found. Authoritative references for an OOTA wrapper are the official docs, the POV-Wiki, and the AGPL source repo.

## Toolchains
| lang | install | invoke |
|---|---|---|
| POV-Ray SDL (native) | `brew install povray` | author `scene.pov` in SDL, then `povray +Iscene.pov +Ooutput.png +W800 +H600 -D +A`. SDL is the deterministic, diff-friendly markup. macOS stable = 3.7.0.10. |
| Shell | `brew install povray` | `povray +I<in.pov> +O<out.png> +W<w> +H<h> -D +A0.3`. Flags: `+I` input, `+O` output, `+W`/`+H` dims, `-D` disable preview display (headless), `+A` antialias, `+FN` PNG output. Exit 0 on success. |
| Python | `brew install povray && pip install vapory` | community MIT binding: build `Scene` objects in Python; vapory writes SDL and shells out to the `povray` binary; `render_scene()` saves the image. Requires `povray` on PATH. |

## Artifact kind
**image** — primary deliverable is a raster image (PNG via `+FN`; also TGA/PPM/JPEG/EXR/HDR). Input is a `.pov` SDL text file (optionally with `.inc` include files), fully deterministic and diff-friendly. Animation is supported (clock variable + `+KFF`/`+KFI` frame flags) producing image sequences that an external tool (ffmpeg) assembles into video, but POV-Ray itself emits images.

## Validation
- **install**: `brew install povray && povray --version`
- **smoke**:
  ```bash
  cat > /tmp/oota_smoke.pov <<'EOF'
  #version 3.7;
  global_settings { assumed_gamma 1.0 }
  camera { location <0,2,-4> look_at <0,0,0> }
  light_source { <5,8,-5> color rgb 1 }
  sphere { <0,0,0>, 1 texture { pigment { color rgb <0.2,0.5,0.9> } finish { phong 0.8 reflection 0.2 } } }
  plane { y, -1 pigment { checker color rgb 1 color rgb 0.3 } }
  EOF
  povray +I/tmp/oota_smoke.pov +O/tmp/oota_smoke.png +W400 +H300 -D +A0.3 && ls -l /tmp/oota_smoke.png && file /tmp/oota_smoke.png
  ```
- **expect**: `povray` exits 0, prints render stats to stderr, and writes `/tmp/oota_smoke.png` as a 400x300 PNG (`file` reports `PNG image data, 400 x 300`). Runs fully headless — `-D` suppresses any display window. Deterministic: identical scene yields identical bytes.

## Wrapper params
- `3d-shaders.title` — scene name / source filename.
- `3d-shaders.width` / `3d-shaders.height` — output dimensions (`+W`/`+H`).
- `3d-shaders.antialias` — antialias threshold (`+A`); explicit value for repeatable AA.
- `3d-shaders.format` — output format (png, tga, ppm, jpeg, exr, hdr → `+FN`/`+FT`/etc.).
- `3d-shaders.source` — the `.pov` SDL source (textarea bound to `src/scene.pov`).

## Component / explorer notes
The image artifact shell renders the PNG directly. The source artifact is the `.pov` (+ `.inc`) text — fully deterministic and version-controllable. Note POV-Ray "shaders" are CPU SDL texture/finish/pigment/normal/media blocks plus a procedural pattern function language, not GPU GLSL. Rendering is single-machine CPU; large scenes are slow but reproducible. AGPL-3.0-or-later: distributing a modified `povray` binary triggers source-availability obligations, but driving the unmodified CLI and authoring SDL scenes does not. macOS caveat: the project ships official binaries only for Windows; macOS users get the Unix/console build via Homebrew — pin the version (3.7.0.10) since Homebrew tracks maintenance releases.
