<!-- generated draft — needs validation -->
# knitout (textiles)

## Summary
knitout is a machine-independent, low-level instruction file format (`.k`, UTF-8 text)
for industrial / whole-garment knitting machines, maintained by the CMU Textiles Lab.
A knitout file starts with a `;!knitout-VERSION` magic header line, followed by a
`;;`-prefixed comment header (Machine, Gauge, Yarn-N, Carriers, Position...) and then a
sequence of opcode lines (`knit`, `tuck`, `miss`, `split`, `xfer`, `drop`, `in`/`out`,
`inhook`/`outhook`, `releasehook`). It is the intermediate representation between design
tools and machine backends — e.g. `knitout-to-dat` (Shima Seiki SWG) and
`knitout-backend-kniterate` (Kniterate). The primary deliverable is a text instruction
file whose physical output is knitted fabric; rich 2D/3D in-browser visualizers exist for
inspecting it.

## Skills
| Type | Name | URL | Official? | License | Attribution |
|------|------|-----|-----------|---------|-------------|
| official-docs | Knitout (.k) File Format Specification v0.6 | https://textiles-lab.github.io/knitout/knitout.html | official | MIT | CMU Textiles Lab |
| repo | textiles-lab/knitout (spec repo) | https://github.com/textiles-lab/knitout | official | MIT | CMU Textiles Lab |
| repo | textiles-lab/knitout-examples (sample .k files) | https://github.com/textiles-lab/knitout-examples | official | MIT | CMU Textiles Lab |
| tool | knitout-live-visualizer (2D in-browser render) | https://textiles-lab.github.io/knitout-live-visualizer/ | official | MIT | CMU Textiles Lab |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node) | `npm i knitout` | `const knitout=require('knitout'); let w=new knitout.Writer({carriers:['1','2','3']}); w.inhook('1'); w.knit('+','f0','1'); w.write('out.k')` |
| Python | `git clone https://github.com/textiles-lab/knitout-frontend-py` (no PyPI; vendor `knitout.py`) | `import knitout; w=knitout.Writer('1 2 3'); w.ingripper('1'); w.knit('+',('f',0),1); w.write('out.k')` |
| Python (DSL) | `pip install knit-script` | higher-level knitting DSL/language that compiles to knitout (Northeastern ACT Lab, community) |
| Native CLI / Node backend | `git clone https://github.com/textiles-lab/knitout-backend-kniterate` | `node knitout-to-dat.js in.k out.dat` — converts `.k` to machine format (Shima `.dat` / Kniterate); drives physical hardware |

## Artifact kind
`text` — the primary deliverable is the raw `.k` instruction file (UTF-8). The richer
explorer is the live-visualizer (2D stitch render) or Knitout-3D-Visualizer (three.js),
which can be embedded alongside the source for inspection.

## Validation
- **install:** `npm i knitout`
- **smoke:** `node -e "const k=require('knitout');const w=new k.Writer({carriers:['1','2','3']});w.inhook('1');for(let n=0;n<10;n++)w.knit('+','f'+n,'1');w.outhook('1');w.write('out.k')"`
- **expect:** Creates `out.k`: a UTF-8 text file starting with a `;!knitout-2` magic line, a
  `;;Carriers` header, then `knit`/`inhook`/`outhook` instruction lines. Open in the live
  visualizer (https://textiles-lab.github.io/knitout-live-visualizer/) to render the fabric
  in 2D. Works headless on macOS.

## Wrapper params
- `carriers` (required) — yarn carrier list, e.g. `1, 2, 3`
- `machine` — machine name for the comment header (e.g. SWG091N2)
- `gauge` — machine gauge / needles per inch
- `width` — needle count / fabric width
- `rows` — number of knit rows
- `direction` — pass direction (`+` / `-`)
- `backend` — output backend toggle: SWG `.dat` vs Kniterate

## Component / explorer notes
The default text artifact shell shows the raw `.k` instruction list fine, but the meaningful
deliverable wants a richer explorer: the textiles-lab **knitout-live-visualizer** (2D stitch
render, in-browser, live-coding) or **Knitout-3D-Visualizer** (three.js 3D). Ideal wrapper
embeds the live-visualizer iframe and shows source + rendered fabric side-by-side.
