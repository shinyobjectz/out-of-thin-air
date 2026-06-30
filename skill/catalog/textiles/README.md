# textiles

Knitting/embroidery from code — physical thread output (machine-ready stitch files generated headlessly).

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [turtlestitch](./turtlestitch.md) | svg | Python (turtlethread on pyembroidery), Python low-level (pyembroidery); JS/Snap! browser is GUI-only (no headless) | [TurtleThread docs (code-driven equiv of TurtleStitch)](./turtlestitch.md) | no | ok | yes | yes |
| [knitout](./knitout.md) | text | JS/TS (Node: npm i knitout), Python (knitout-frontend-py / knit-script DSL), Node backends (knitout-to-dat, knitout-backend-kniterate) | [Knitout (.k) File Format Spec v0.6 — CMU Textiles Lab](./knitout.md) | yes | ok | yes | yes |

## Multi-toolchain notes

- **turtlestitch**: Python only for headless work — `turtlethread` (high-level turtle API → SVG + .dst/.exp/.pes) or `pyembroidery` (low-level raw stitch read/write/convert). The original TurtleStitch is a browser Snap! app with no CLI/API; not usable in a build pipeline. No Go/React/native paths.
- **knitout**: Broadest toolchain coverage. JS/TS via npm `knitout` Writer. Python via `knitout-frontend-py` (git, not on PyPI) or the `knit-script` DSL (PyPI). Node backends compile .k to machine formats (`knitout-to-dat`, `knitout-backend-kniterate`). No Go/native.

## VALIDATION ORDER

Cheapest / most-reliable installs first:

1. **knitout** — `npm i knitout`, single npm dep, pure-JS Writer, smoke writes `out.k` (text). Most reliable; no native/Python toolchain needed.
2. **turtlestitch** — `python3 -m venv venv && ./venv/bin/pip install turtlethread`, needs a venv + pip install (pyembroidery under it), smoke writes `square.svg` + `square.dst`. Slightly heavier (Python env) but still fully headless on macOS.

## EXPLORER NEEDS

Both tools emit instruction/stitch-path files whose default shell preview is thin; richer explorers:

- **knitout** — artifact is raw `.k` text; richer = [textiles-lab knitout-live-visualizer](https://textiles-lab.github.io/knitout-live-visualizer/) (2D) and Knitout-3D-Visualizer for stitch rendering.
- **turtlestitch** — SVG is the preview shell; the `.dst`/`.exp`/`.pes` machine files have no dedicated shell kind and want an embroidery-stitch viewer to inspect actual thread paths.

## Dossiers

- [./turtlestitch.md](./turtlestitch.md)
- [./knitout.md](./knitout.md)
