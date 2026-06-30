<!-- generated draft — needs validation -->
# openscad (cad)

## Summary
OpenSCAD is a script-only (code-as-CAD) solid modeler. You write `.scad` files in its declarative CSG (constructive solid geometry) language and the engine renders parametric 3D models. The CLI exports STL/OFF/3MF/AMF (model3d) and PNG previews fully headless via `-o`. The primary deliverable is a 3D model (STL/3MF). Toolchain coverage is strong: native CLI plus Python wrappers (SolidPython2, OpenPySCAD, PythonOpenSCAD) and a WASM build for browser/Node. A real Claude/agent skill ecosystem exists (mitsuhiko/agent-stuff, iancanderson/openscad-agent).

## Skills
| Skill | Type | Official | Attribution | License | URL |
|---|---|---|---|---|---|
| mitsuhiko agent-stuff: openscad | community | no | Armin Ronacher (mitsuhiko) | check repo (Apache-2.0/MIT typical) | https://github.com/mitsuhiko/agent-stuff |
| iancanderson/openscad-agent | repo | no | Ian Anderson | see repo | https://github.com/iancanderson/openscad-agent |
| zacharyfmarion/openscad-studio | repo | no | Zachary Marion | see repo | https://github.com/zacharyfmarion/openscad-studio |
| OpenSCAD CLI manual (official docs) | official-docs | yes | OpenSCAD project | GFDL | https://files.openscad.org/documentation/manual/Using_OpenSCAD_in_a_command_line_environment.html |

## Toolchains
| lang | install | invoke |
|---|---|---|
| native CLI | `brew install --cask openscad` (macOS); `apt install openscad` (Linux) | `openscad -o out.stl in.scad` ; PNG: `openscad -o out.png in.scad --imgsize=800,600 --camera=0,0,0,55,0,25,140`. macOS binary at `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`. |
| Python (solidpython2) | `pip install solidpython2` | build obj in Python; `scad_render_to_file(obj,'out.scad')` then `openscad -o out.stl out.scad` |
| Python (openpyscad) | `pip install openpyscad` | `(c1+c2).write('out.scad')` then `openscad -o out.stl out.scad` |
| Python (pythonopenscad) | `pip install pythonopenscad` | SolidPython/OpenPySCAD API styles; meshes via manifold3d backend — exports STL WITHOUT the OpenSCAD binary |
| JS/TS (openscad-wasm) | `npm install openscad-wasm` | WASM engine compiles `.scad`→STL in browser/Node without a native install |
| any (shell) | (same as native CLI) | generate `.scad` text from any language, then invoke `openscad` CLI to export — universal fallback |

## Artifact kind
**model3d** — primary deliverable is a 3D model (STL/3MF/OFF). PNG export gives a flat preview for shells without a 3D viewer.

## Validation
- **install**: `brew install --cask openscad`
- **smoke**: `printf 'cube([20,20,20]);' > /tmp/c.scad && /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o /tmp/c.stl /tmp/c.scad && /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o /tmp/c.png /tmp/c.scad --imgsize=512,512`
- **expect**: Exits 0; `/tmp/c.stl` is a valid ASCII STL (starts with `solid`) of a 20mm cube and `/tmp/c.png` is a 512x512 preview. STL export is fully headless; PNG renders natively on macOS (Linux PNG may need Xvfb).

## Wrapper params
- `cad.title` — model name / source filename.
- `cad.format` — output: stl, 3mf, off, png.
- `cad.fn` — facet resolution (`$fn`) for curved surfaces.
- `cad.imgsize` — PNG dimensions (when format=png).
- `cad.projection` — ortho | perspective for preview.
- `-D var=value` — override top-level parameters to drive parametric variants.
- `--render` — force full CGAL render vs fast preview.

## Component / explorer notes
The model3d artifact shell (glTF/STL viewer with orbit controls) renders the STL/3MF well. PNG export gives a flat preview for shells without a 3D viewer. A richer Customizer-style explorer with parameter sliders adds value but is not required.
