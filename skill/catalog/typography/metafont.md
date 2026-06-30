<!-- generated draft — needs validation -->
# metafont (typography)

## Summary
METAFONT is Donald Knuth's parametric font-description language and companion to TeX. A `.mf` program defines glyphs as pen-stroke paths and filled regions parameterized by equations (stroke width, slant, x-height, serif size, etc.); changing parameters yields a whole family from one source — a "meta-font". The `mf` engine rasterizes source to bitmap font rasters (GF format) plus TFM metric files. There is no first-class SDK in any modern language; it is driven as a native CLI shipped in TeX Live / MacTeX, with a Perl helper (`mf2pt1`) and MetaPost (`mpost`) for vector/Type1 output. Primary deliverable is a rendered glyph/proof bitmap, so the natural shell artifact is an **image** (PNG of a proof sheet or glyph sample).

## Skills (attributed references)
| Name | URL | Official? | License | Attribution |
|------|-----|-----------|---------|-------------|
| The METAFONTbook / mf(1) man page | https://www.mankier.com/1/mf | official | man page (TeX Live docs); book © Addison-Wesley | Donald E. Knuth / TeX Live |
| Metafont — Wikipedia overview (format, GF/TFM output, pen model) | https://en.wikipedia.org/wiki/Metafont | community | CC BY-SA | Wikipedia contributors |
| mf2pt1 manual — Metafont source to PostScript Type 1 | https://www.ctan.org/pkg/mf2pt1 | community | LPPL (CTAN) | Scott Pakin, Werner Lemberg |
| METAFONT for Beginners (tutorial PDF) | http://ftp.cvut.cz/tex-archive/info/metafont/beginners/metafont-for-beginners.pdf | community | free doc (CTAN) | Christophe Grandsire et al. |
| GitHub topic: metafont (community repos/examples) | https://github.com/topics/metafont | community | varies per repo | various |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| native CLI (web2c mf engine) | `brew install --cask mactex-no-gui` (or `brew install texlive`) — provides `mf`, `mf-nowin`, `mpost`, `gftopk`, `gftodvi`, `mftogf` | `mf-nowin '\mode=localfont; mag=1; nonstopmode; input FONT.mf'` → emits `FONT.<dpi>gf` + `FONT.tfm`; render proof with `gftodvi` + `dvipng` |
| native CLI (vector path) | `brew install texlive t1utils fontforge` | `mf2pt1 FONT.mf` — drives `mpost` to produce PostScript Type 1 outlines (every glyph must be closed fill/unfill paths) |
| Perl wrapper | included in TeX Live (or download `mf2pt1.pl` from CTAN) | `perl mf2pt1.pl --rounding=... FONT.mf` — CLI-style wrapper, not a library. No Python/JS/Go/Rust binding exists — drive `mf` via subprocess in those languages |

## Artifact kind
**image** — native output (GF) is a bitmap raster, not browser-renderable directly. The shell displays a rendered proof PNG via `gftodvi` + `dvipng`, or a single-glyph sample.

## Validation
- **install:** `brew install --cask mactex-no-gui` (adds `mf-nowin`, `gftopk`, `gftodvi`, `dvipng` to PATH — restart shell)
- **smoke:** `cd /tmp && mf-nowin '\mode=localfont; mode_setup; mag=4; nonstopmode; input cmr10' && ls -l cmr10.*gf cmr10.tfm`
- **expect:** Exit 0. Produces `cmr10.<dpi>gf` (e.g. `cmr10.2602gf`) and `cmr10.tfm` in `/tmp`. `cmr10.mf` ships with TeX Live, so no source file needed. For a viewable PNG proof: `gftodvi cmr10.2602gf && dvipng -D150 -o cmr10-proof.png cmr10.dvi`.

## Wrapper params
Key params worth exposing: the design parameter block a `.mf` font defines (e.g. cmr-style `u#` unit width, `cap_height#`, `x_height#`, `slant`, stroke widths, serif params), plus engine knobs `mode` (proof / localfont / ljfour), `mag` (magnification → output dpi), and `nonstopmode` for headless batch. For vector output, expose `mf2pt1` flags. Output filename is `jobname.<dpi>gf`, so callers must derive dpi from mode × mag.

## Component / explorer notes
Native GF output is a bitmap, not directly browser-renderable. The image shell can display a rendered proof PNG (gftodvi + dvipng) or a single-glyph sample. A richer explorer would expose parameter sliders (stroke width, slant, x-height) that re-run `mf` and live-update the proof image — the compelling demo for a "meta-font".
