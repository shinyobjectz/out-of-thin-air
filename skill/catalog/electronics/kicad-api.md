# kicad-api (electronics)

## Summary

"kicad-api" most precisely names KiCad's **IPC API** (KiCad 9.0+), driven from Python
via the official **kicad-python** bindings. The IPC API sends Protobuf messages over
NNG / a Unix socket to remotely control a **running** KiCad instance (PCB / schematic
editor). It is *not* headless — KiCad must be open with the API server enabled
(Preferences > Plugins).

For true oota schematic / code-as-PCB workflows that emit netlists and reusable
blocks without a GUI, **SKiDL** (a separate library) describes circuits in Python and
calls `generate_netlist()` to emit a KiCad-compatible `.net` netlist. **kicad-cli**
(ships with KiCad) plots boards and schematics to SVG/PDF/PNG headlessly.

The primary deliverable is a circuit/board design. The netlist is plain text; the
renderable artifact is an **SVG** (or PDF/PNG) plot of the schematic or PCB. Because
the official IPC binding is not headless, the recommended smoke test uses SKiDL +
kicad-cli.

## Skills

| Skill | Type | License | URL |
|-------|------|---------|-----|
| KiCad Developer Docs — IPC API / kicad-python | official-docs | KiCad docs (CC/GFDL) | https://dev-docs.kicad.org/en/apis-and-binding/ipc-api/ |
| kicad-python auto-generated API reference | official-docs | MIT (library) | https://docs.kicad.org/kicad-python-main/ |
| IPC API for Add-on Developers guide | official-docs | KiCad docs | https://dev-docs.kicad.org/en/apis-and-binding/ipc-api/for-addon-developers/index.html |
| Developers guide to the KiCad Protobuf IPC API (kbralten gist) | community | unspecified | https://gist.github.com/kbralten/52ad5a56d09ff01cf42e4d338f57e022 |
| SKiDL docs — oota schematic in Python | community | MIT | https://devbisme.github.io/skidl/ |
| Code-Based PCB Design with KiCad Scripting (SiliconWit) | community | unspecified | https://siliconwit.com/education/pcb-design-kicad/code-based-pcb-design-kicad-scripting/ |

## Toolchains

| lang | install | invoke |
|------|---------|--------|
| Python (kicad-python) | `pip install kicad-python` | `from kicad import KiCad; kicad = KiCad(); board = kicad.get_board()` — needs KiCad 9.0+ RUNNING with API server enabled (NOT headless) |
| Python (SKiDL) | `pip install skidl` | declare `Part`/`Net`, then `generate_netlist(file_='out.net')` — fully headless, the practical schematics-as-code path |
| native CLI (kicad-cli) | `brew install --cask kicad` | `kicad-cli pcb export svg board.kicad_pcb -o board.svg` / `kicad-cli sch export netlist|svg|pdf` — headless export |
| Python (pcbnew SWIG, legacy) | ships inside KiCad app | `import pcbnew` — PCB editor only; superseded by IPC API |

## Artifact kind

**svg** — a schematic/PCB plot exported by kicad-cli. The netlist itself is text;
the meaningful visual artifact is the SVG (PDF/PNG also supported).

## Validation

- **install:** `pip install skidl && (brew install --cask kicad || true)`
- **smoke:**
  ```bash
  python3 -c "from skidl import Part, Net, generate_netlist; r=Part('Device','R',value='1k',footprint='Resistor_SMD:R_0805_2012Metric'); c=Part('Device','C',value='1u',footprint='Capacitor_SMD:C_0805_2012Metric'); n=Net('SIG'); n += r[1], c[1]; generate_netlist(file_='rc.net')"
  ```
- **expect:** Writes `rc.net` (a KiCad-format netlist text file) listing R/C components
  on net SIG. (Needs KiCad symbol/footprint libs for full ERC. For an SVG/PDF artifact
  instead, open a `.kicad_pcb` and run `kicad-cli pcb export svg board.kicad_pcb -o board.svg`.)

## Wrapper params

- **kicad-python:** socket connection (default Unix socket / `KICAD_API_SOCKET`),
  target document (board vs schematic), require-running-KiCad flag.
- **SKiDL:** backend/tool (`kicad`), output netlist path, footprint library env
  (`KICAD_SYMBOL_DIR`), ERC on/off.
- **kicad-cli export:** format (svg/pdf/png/gerber), layers, black-and-white/theme.

## Component / explorer notes

Netlist output is plain text. The meaningful visual artifact is a schematic/PCB plot —
an SVG (or PDF/PNG) from kicad-cli. The default image/SVG shell renders it fine for
preview. An interactive board explorer (layer toggles, pan/zoom, net highlight) would
add value but isn't required.
