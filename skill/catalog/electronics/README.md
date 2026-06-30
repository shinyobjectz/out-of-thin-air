# electronics

Schematics/PCB as code — netlists, reusable blocks. Describe circuits in code (Python), emit KiCad netlists (text) and schematic/PCB plots (SVG).

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [skidl](./skidl.md) | text (KiCad netlist) | Python (`pip install skidl` → `python circuit.py`) | [SKiDL docs](https://devbisme.github.io/skidl/) | yes | ok | yes | yes (pre-existing) |
| [kicad-api](./kicad-api.md) | svg (schematic/PCB plot; netlist is text) | Python/skidl; native/kicad-cli; Python/kicad-python (not headless); Python/pcbnew SWIG | [SKiDL docs](https://devbisme.github.io/skidl/) | no | ok | yes | yes |

## Multi-toolchain notes

- **skidl** — Python-only. No CLI/Go/JS-TS/React/Rust bindings. Single deliverable: KiCad S-expression text netlist.
- **kicad-api** — multi-path:
  - Python/skidl → `generate_netlist()` (headless, text netlist).
  - native/`kicad-cli` → `kicad-cli pcb export svg` (headless, SVG artifact).
  - Python/kicad-python (IPC) → `KiCad()` — NOT headless; needs running KiCad 9.0+ with API server enabled.
  - Python/pcbnew SWIG (legacy) → ships in KiCad app.
- No Go / JS-TS / React native bindings in either tool. Headless code-as-X path = SKiDL (netlist) + kicad-cli (SVG plot).

## VALIDATION ORDER

1. **skidl** — cheapest, most reliable. Pure-Python pip install in a venv; `python vdiv.py` → `vdiv.net`. Caveat: Part lookup needs KiCad symbol libs + `KICAD_SYMBOL_DIR`.
2. **kicad-api** — heavier. Reuses skidl for the netlist smoke; the SVG artifact requires the full KiCad cask (`brew install --cask kicad`, large) for `kicad-cli pcb export svg`. Validate skidl path first; only pull KiCad cask for the SVG leg.

## EXPLORER NEEDS

- **skidl** — default artifact shell adequate (text netlist; render with a code/text viewer).
- **kicad-api** — wants a richer explorer: SVG schematic/PCB plot viewer (pan/zoom on board layers). Future 3D board orbit (kicad-cli can export 3D) would benefit from a CAD-style orbit explorer beyond the flat SVG shell.

## Dossiers

- [skidl](./skidl.md)
- [kicad-api](./kicad-api.md)
