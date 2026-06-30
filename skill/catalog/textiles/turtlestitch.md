<!-- generated draft — needs validation -->
# textiles / turtlestitch

## Summary
TurtleStitch is a browser-based, Snap! (visual blocks) programming environment for generating
embroidery-machine patterns from turtle-graphics code. It exports machine stitch files (Melco/EXP,
Tajima/DST), plus SVG and PNG previews. It is fundamentally a GUI/web app: there is **no headless
CLI or scriptable API** for batch generation. Its `docs/API.md` only documents manipulating the
Snap! UI from injected JS, not driving stitch output from a terminal.

The programmable, automatable path to the same artifact is the Python library **TurtleThread**
(a `turtle.Turtle`-compatible API on top of **pyembroidery**), which is what this build uses for
headless/scripted generation. Primary digital deliverable maps to the **SVG** shell kind (vector
preview of the stitch path). The ultimate physical output is thread on fabric; the true machine
artifact (`.dst`/`.exp`/`.pes`) has no dedicated shell kind, so SVG is the preview deliverable.

Confidence: medium — TurtleStitch core is not scriptable, so the toolchains/validation below are
the TurtleThread/pyembroidery de-facto code-driven equivalents.

## Skills (attributed references)
| Skill / doc | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| TurtleStitch official site / FAQ / resources | official-docs | https://www.turtlestitch.org/ | yes | AGPL-3.0 (software) | backface (Michael Aschauer) et al. |
| backface/turtlestitch (source, OFFLINE.md, docs/API.md, docs/Extensions.md) | repo | https://github.com/backface/turtlestitch | yes | AGPL-3.0 | backface (Michael Aschauer) |
| TurtleThread docs (Python turtle-interface for embroidery) | official-docs | https://turtlethread.com/ | no (community) | GPLv3 | Marie Roald & Yngve Mardal Moe |
| TurtleThread/TurtleThread repo | repo | https://github.com/TurtleThread/TurtleThread | no (community) | GPLv3 | Marie Roald & Yngve Mardal Moe |
| EmbroidePy/pyembroidery (format read/write engine) | repo | https://github.com/EmbroidePy/pyembroidery | no (community) | MIT | EmbroidePy |

No Anthropic/Claude SKILL.md or llms.txt exists for turtlestitch.

## Toolchains
| lang | install | invoke |
|---|---|---|
| JS / Snap! (browser, native env) | `git clone https://github.com/backface/turtlestitch && open index.html` (or use turtlestitch.org / GitHub Pages; see OFFLINE.md) | GUI only — author visual blocks, then Export menu (DST/EXP/SVG/PNG). No headless/batch path. |
| Python (turtle API) | `pip install turtlethread` | `t = turtlethread.Turtle(); ...; t.save('out.svg'); t.save('out.dst')` — headless, ideal for automation. |
| Python (low-level) | `pip install pyembroidery` | Read/write/convert DST, EXP, PES, JEF, SVG, PNG directly when you need raw stitch-list control. |

## Artifact kind
**svg** — vector preview of the exported stitch path. (True machine files `.dst`/`.exp`/`.pes` are
emitted alongside but have no dedicated shell kind.)

## Validation
- **install:** `python3 -m venv venv && ./venv/bin/pip install turtlethread`
- **smoke:**
  ```bash
  ./venv/bin/python -c "import turtlethread; t=turtlethread.Turtle()
  with t.running_stitch(30):
      for _ in range(4):
          t.forward(200); t.right(90)
  t.save('square.svg'); t.save('square.dst')"
  ```
- **expect:** Writes `square.svg` (vector preview of a stitched square path, openable in any browser/
  SVG viewer) and `square.dst` (Tajima machine file). Runs fully headless on macOS, no GUI. For
  TurtleStitch core itself there is no headless smoke test — output is produced interactively in the
  browser then exported via the Export menu.

## Wrapper params
Exposed via the TurtleThread code path:
- **stitch length** — `running_stitch(length)`
- **stitch type** — running / jump / satin / zigzag (width)
- **thread color** — color blocks
- **hoop / canvas dimensions**
- **export format** — svg/png (preview) vs dst/exp/pes/jef (machine)

For TurtleStitch proper, the meaningful "param" is the Snap! script itself plus export-menu toggles
(format choice, "ignore colors during export" for multicolor → single-color).

## Component / explorer notes
The default SVG artifact shell renders the exported vector stitch-path fine for preview. A richer
explorer would help for the real machine files (`.dst`/`.exp`/`.pes`): a stitch viewer showing
stitch order, jump/trim stitches, color blocks, and stitch count — none of which the plain SVG
shell conveys. PNG export exists purely as a flat preview image.
