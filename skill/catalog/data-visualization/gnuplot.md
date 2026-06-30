<!-- generated draft — needs validation -->
# gnuplot

- slug: `gnuplot`
- category: `data-visualization`
- artifact kind: `svg`

## Summary

gnuplot is a portable, command-driven graphing utility that renders 2D/3D plots
from plain-text scripts. Plots are authored as deterministic, version-controllable
`.gp`/`.plt` scripts (plus accompanying data files) and rendered fully headless in
batch mode — no GUI/display needed. Current stable release is 6.0.4 (Dec 21, 2025);
6.0.3 was June 2025; dev branch is 6.1. Output terminals cover vector (svg, pdf via
pdfcairo, eps, LaTeX/tikz/epslatex) and raster (pngcairo, png, jpeg). Primary
deterministic deliverable for OOTA is **SVG** (vector, diffable-ish, exact
reproducible geometry); PDF and PNG are equally first-class. Driven from the gnuplot
CLI directly, or embedded from Python (matplotlib-free) via PyGnuplot/gnuplotlib
subprocess wrappers, and from any language by piping a script to the `gnuplot` binary.
No official Anthropic/Claude skill exists; community resources only.

## Skills / references

| Name | Type | Official | URL | Attribution | License |
|------|------|----------|-----|-------------|---------|
| No official Anthropic/Claude skill | none | no | https://github.com/anthropics/skills | Anthropic skills repo searched; no gnuplot skill present | n/a |
| Official gnuplot documentation (ReadTheDocs / gnuplot.info) | docs | yes | https://gnuplot.readthedocs.io/en/latest/ | gnuplot project (Williams, Kelley, et al.) | gnuplot license (permissive, BSD-like with derivative-source clause) |
| gnuplotting.org tutorials & output-terminal recipes | community-docs | no | http://gnuplotting.org/output-terminals/index.html | gnuplotting.org | site content (tutorials) |
| gnuplot source repo (SourceForge canonical; GitHub mirror) | source | yes | https://github.com/gnuplot/gnuplot | gnuplot dev team | gnuplot license |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| shell/CLI | `brew install gnuplot` | `gnuplot script.gp` or `gnuplot -e "set terminal svg; set output 'out.svg'; plot sin(x)"` — batch/headless, no DISPLAY when terminal is a file format |
| python | `pip install gnuplotlib` (numpy-based) or `pip install PyGnuplot` | thin subprocess wrapper around the `gnuplot` binary (install separately via brew); gnuplotlib is numpy-centric, PyGnuplot is a simpler pipe wrapper |
| any (subprocess/pipe) | `brew install gnuplot` | write a `.gp` script (or heredoc) and pipe to `gnuplot`: `echo 'set term pdfcairo; set output "o.pdf"; plot x*x' | gnuplot` — works from Node, Ruby, R, Perl, Make |

## Artifact kind

`svg` — vector, deterministic, exact reproducible geometry. PDF (pdfcairo) and PNG
(pngcairo) are equally first-class alternative outputs.

## Validation

- **install:** `brew install gnuplot && gnuplot --version`
- **smoke:**
  ```bash
  printf 'set terminal svg size 640,480\nset output "smoke.svg"\nset title "OOTA gnuplot smoke"\nplot [-10:10] sin(x) with lines title "sin(x)"\n' | gnuplot && ls -la smoke.svg && head -c 200 smoke.svg
  ```
- **expect:** `gnuplot --version` prints e.g. `gnuplot 6.0 patchlevel 4`. The pipe
  runs headlessly (no DISPLAY) and writes smoke.svg; ls shows a non-empty file (a few
  KB) and head shows `<?xml ...` / `<svg ...` markup. Exit code 0, no GUI window. Swap
  terminal to `pdfcairo`->smoke.pdf or `pngcairo`->smoke.png for the other artifact kinds.

## Wrapper params

- `data-visualization.title` (text) — plot title.

## Component / explorer notes

Deliverable is a gnuplot script (`.gp`/`.plt`) plus any input data files (`.dat`/CSV).
The script is fully deterministic: same script + data + gnuplot version => byte-stable
vector output (SVG/PDF). Pin terminal explicitly (`set terminal svg`/`svgcairo`,
`pdfcairo`, `pngcairo`) and `set output` to a file — never rely on an interactive
terminal. Set `set term ... font ...` and fixed `size` for reproducibility; avoid
time/date auto-stamps in titles. SVG and PDF are vector (preferred deterministic kinds);
PNG raster via cairo is also reproducible. Keep data inline (heredoc/`$datablock`) or as
committed `.dat` files so the artifact is self-contained.

macOS: install via Homebrew (`brew install gnuplot`); the bottle includes cairo/pango
(pngcairo, pdfcairo) and libgd terminals — verify with `gnuplot -e "set terminal" 2>&1`
to list available terminals. No X11/DISPLAY required for file-output terminals; do NOT
use the `qt`/`x11`/`wxt` interactive terminals in headless pipelines. Pin the gnuplot
major.minor (6.0.x) since terminal defaults can shift across majors. Fonts: pdfcairo/svg
embed font names, not glyphs — for fully portable PDFs prefer `epslatex`/`cairolatex`
only if a LaTeX step is acceptable, otherwise stick to common fonts.
