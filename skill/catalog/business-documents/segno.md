# Segno (QR)

## Summary
Segno is a pure-Python QR Code and Micro QR Code encoder (no dependencies) implementing ISO/IEC 18004:2015(E). It serializes to SVG, PNG, EPS, PDF, Netpbm, LaTeX/PGF-TikZ, XBM, and XPM with no external libs, and ships high-level helpers for vCard/MeCard, WiFi, and EPC payloads plus Structured Append. Fully deterministic for fixed input/version/error/mask, headless, and CLI-drivable. Latest line is 1.6.x (1.6.6, March 2025). For OOTA the primary deliverable is a vector SVG (deterministic, diffable, version-controllable); PNG is the secondary raster output.

Confidence: high.

## Skills
- No official Anthropic/Claude skill (none found as of 2026-06).
- [heuer/segno](https://github.com/heuer/segno) — canonical source + docs. Official library repo by Lars Heuer (heuer). License: BSD-3-Clause.
- [Segno documentation](https://segno.readthedocs.io/) — official docs, Segno project. License: BSD-3-Clause.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.x, pure Python, no native deps) | `pip install segno` | `import segno; segno.make('data').save('out.svg', scale=8, border=4)` — also `.save('out.png')`. Deterministic given version/error/mask. PNG export is built-in (no Pillow needed). |
| Shell/CLI (segno console script, installed with the pip package) | `pip install segno` | `segno "Hello World" -o out.svg --scale 8 --border 4 --error h` — format inferred from file extension. Use `--output /dev/stdout` for terminal preview. |

## Artifact kind
`svg` — SVG output is text/XML (diffable, editable, infinitely scalable), the OOTA-preferred kind. PNG is the raster fallback.

## Validation
- **install:** `python3 -m venv /tmp/segno-env && /tmp/segno-env/bin/pip install segno`
- **smoke:** `/tmp/segno-env/bin/python -c "import segno; segno.make('https://oota.example', error='m').save('/tmp/oota-qr.svg', scale=8, border=4)" && head -c 40 /tmp/oota-qr.svg`
- **expect:** Exit 0; `/tmp/oota-qr.svg` exists and begins with an XML/SVG header (e.g. `<?xml` / `<svg`). Re-running produces a byte-identical file (deterministic). CLI equivalent: `/tmp/segno-env/bin/segno 'https://oota.example' -o /tmp/oota-qr.png --scale 8` emits a valid PNG. Runs fully headless on macOS, no display/browser required.

## Wrapper params
Wrap as a thin Python CLI/function taking `(data, kind=svg|png, error, scale, border, dark/light colors)` and writing one file. Map OOTA artifactKind to extension: svg -> .svg, image -> .png. Avoid Segno's interactive/animated outputs for deterministic deliverables. No external binaries needed; pure pip install makes it trivial to sandbox. For colored/branded codes use `save(dark=..., light=...)` but keep params fixed for reproducibility. No GUI/headless-browser dependency — pure file emission.

## Component / explorer notes
QR generation is deterministic: same data + version + error level + mask + scale/border yields identical SVG/PNG bytes, ideal for version control and diffing. Pin error correction and mask explicitly (e.g. `error='m'`, `mask=N`) to guarantee reproducibility; default mask auto-selection is also deterministic but tie behavior to the version. SVG output is text/XML so it's the OOTA-preferred kind; PNG is the raster fallback. Supports Micro QR, multi-symbol Structured Append, and typed payloads (`segno.helpers.make_wifi`, `make_vcard`, `make_epc_qr`).
