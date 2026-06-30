# Matplotlib

slug: `matplotlib` · category: `data-visualization` · artifact kind: **image**

## Summary

Matplotlib is the canonical Python plotting library. For OOTA it is ideal: a
plotting script is deterministic, version-controllable code that renders
headlessly to a file via the non-interactive **Agg** backend
(`matplotlib.use('Agg')` + `plt.savefig`). The primary deliverable is a raster
image (PNG); the same code natively emits PDF, SVG, and PS by changing the
`savefig` extension.

Current stable is **3.11.0** (June 12, 2026); 3.10.x is the prior widely
installed line (3.10.0 Dec 2024, 3.10.1 Feb 2025). Installs cleanly via pip
wheels on macOS — no GUI required.

**Determinism caveat:** pin the version and set a fixed font/style + metadata to
avoid byte-diffs across machines. Pin `matplotlib==3.11.0`, set a fixed
`rcParams` style/font (e.g. bundled DejaVu Sans), fixed `dpi`/`figsize`, and
strip embedded timestamps on PDF/SVG via `metadata={'CreationDate': None}`.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| data-visualization (Anthropic knowledge-work / data skills) | skill | official | Apache-2.0 | https://github.com/anthropics/skills |
| Pirat83/claude-code-skills (matplotlib visualization) | skill | community | check repo | https://github.com/Pirat83/claude-code-skills |
| Matplotlib official docs / examples gallery | docs | official | Matplotlib license (PSF-style, BSD-compatible) | https://matplotlib.org/stable/ |

Attribution:
- **data-visualization** — Anthropic. Official skill covering chart-type
  selection plus matplotlib/seaborn/plotly code patterns, design principles,
  and colorblind-accessible palettes.
- **Pirat83/claude-code-skills** — Community: reusable Claude Code skill for
  matplotlib visualization.
- **Matplotlib official docs** — Matplotlib Development Team. Authoritative
  API + headless backend guidance (Backends, savefig).

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.10+) — primary | `python3 -m pip install -U matplotlib` | `MPLBACKEND=Agg python3 plot.py` (or `matplotlib.use('Agg')` before importing pyplot, then `plt.savefig('out.png')`) |
| Julia (1.x) — secondary | `julia -e 'using Pkg; Pkg.add("PythonPlot")'` | PythonPlot.jl / PyPlot.jl call the same CPython matplotlib via PythonCall; still requires a Python matplotlib install underneath |

Python is the primary and effectively only first-class driver.

## Artifact kind

**image** (PNG via Agg). The same script trivially retargets to `pdf`/`svg` by
changing the savefig extension, so OOTA can treat one matplotlib component as a
multi-kind renderer (image | svg | pdf).

## Validation

Install:
```bash
python3 -m pip install -U 'matplotlib==3.11.0'
```

Smoke:
```bash
MPLBACKEND=Agg python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot as plt; fig,ax=plt.subplots(); ax.plot([0,1,2,3],[0,1,4,9]); ax.set_title('smoke'); fig.savefig('/tmp/oota_mpl.png', dpi=120); print('OK')" && file /tmp/oota_mpl.png
```

Expect: prints `OK`; `/tmp/oota_mpl.png` exists and `file` reports it as a PNG
image (e.g. `PNG image data, 800 x 600`). No display/GUI required — runs fully
headless on macOS.

## Wrapper params

- `data-visualization.title` (text) — figure title.
- `data-visualization.ext` (select: png | svg | pdf) — maps to savefig format;
  default png at dpi=150.

Wrap as: take a `.py` plot script (the version-controlled source), execute with
`MPLBACKEND=Agg` forced in the env so it never opens a window, capture the
savefig output path, validate the emitted file with `file` / size > 0.

## Component / explorer notes

Deliverable is a static figure. Build the figure programmatically (no
`plt.show`), always `savefig` to an explicit path. For deterministic output: pin
matplotlib version, set fixed rcParams style/font (DejaVu Sans, bundled), set
fixed dpi/figsize, and set `metadata={'CreationDate': None}` on PDF/SVG to strip
embedded timestamps that otherwise break byte-reproducible diffs. seaborn
(`pip install seaborn`) is an optional higher-level layer on top — same
Agg/savefig mechanics, no extra runtime.
