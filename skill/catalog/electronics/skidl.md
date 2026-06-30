<!-- generated draft — needs validation -->
# skidl (electronics)

## Summary
SKiDL is a Python library for describing electronic circuits as code ("circuit-as-code"). You write a Python program that defines `Part`s, `Net`s, and connections, then call `generate_netlist()` to emit a netlist (primarily KiCad S-expression format) for PCB layout, plus XML BOMs and SPICE simulation. The primary deliverable is a plain-text netlist file. Python-only — no other language bindings exist. MIT licensed, maintained by devbisme (Dave Vandenbout).

## Skills
| Skill | Type | URL | Official | License | Attribution |
|-------|------|-----|----------|---------|-------------|
| SKiDL official documentation site | official-docs | https://devbisme.github.io/skidl/ | yes | MIT | devbisme (Dave Vandenbout) |
| devbisme/skidl (source + README + examples) | repo | https://github.com/devbisme/skidl | yes | MIT | devbisme (Dave Vandenbout) |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Python (CPython 3.x) | `pip install skidl` | `python circuit.py` (import via `from skidl import *`) |

Only supported toolchain. Requires KiCad (5–9) symbol libraries installed and `KICAD_SYMBOL_DIR` set for part lookup; `generate_netlist(tool=KICAD9)` selects the KiCad version. No Go/JS/Rust/CLI bindings exist — there is no standalone `skidl` binary; it is a library driven from a Python script.

## Artifact kind
**text** — the primary deliverable is a plain-text KiCad S-expression netlist (or XML BOM). Renders fine in the default text/code artifact shell. There is no native visual schematic render; to view graphically, import the netlist into KiCad's pcbnew/eeschema.

## Validation
**Install**
```bash
python3 -m venv /tmp/skidlenv && /tmp/skidlenv/bin/pip install skidl
```

**Smoke**
```bash
cat > /tmp/vdiv.py <<'EOF'
from skidl import *
vin, vout, gnd = Net('VI'), Net('VO'), Net('GND')
r1, r2 = 2 * Part('Device','R', dest=TEMPLATE)
r1.value, r2.value = '1K', '500'
vin & r1 & vout & r2 & gnd
ERC()
generate_netlist(file_='/tmp/vdiv.net')
EOF
/tmp/skidlenv/bin/python /tmp/vdiv.py
```

**Expect**
Produces `/tmp/vdiv.net` — a KiCad-format S-expression netlist text file listing components (r1, r2) and nets (VI, VO, GND). `ERC()` prints any warnings to stderr. NOTE: part lookup needs KiCad symbol libs present; if `KICAD_SYMBOL_DIR` is unset, set it to a KiCad `symbols` dir or install KiCad (`brew install --cask kicad` on macOS) first, else `Part('Device','R')` raises a library-not-found error. Runs fully headless.

## Wrapper params
- `generate_netlist(tool=KICAD5..KICAD9, file_=path)` — pick KiCad version and output path.
- `generate_xml()` — emit BOM.
- `ERC()` — toggle electrical-rules checking.
- `Part(lib, name, footprint=..., dest=TEMPLATE)` — component instantiation.
- `KICAD_SYMBOL_DIR` env var — symbol library path.
- `generate_pcb()` / `generate_svg()` — direct layout/preview in recent versions.

## Component / explorer notes
Primary output is a plain-text netlist (KiCad S-expression / XML BOM) — renders in the default text/code artifact shell. No visual schematic render natively; a richer explorer (import into KiCad eeschema/pcbnew) is optional, not required, for the text deliverable.
