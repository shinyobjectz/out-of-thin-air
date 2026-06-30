# tracery

## Summary
Tracery is Kate Compton's (galaxykate) story-grammar generation library. You feed it a JSON/dict grammar of symbols and expansion rules; it expands a `#origin#` rule recursively (with optional modifiers like `.capitalize`, `.a`, `.s`) into a flattened string. The primary deliverable is plain text — bots, dialogue, procedural names, poems, tweets. It is pervasive in the botmaker / Cheap Bots Done Quick community. The original JS library is unmaintained (last meaningful work ~2015) but ports remain active; `pytracery` is the cleanest CLI-friendly toolchain.

## Skills (attributed references)
| Skill | Type | URL | Official? | License | Attribution |
|-------|------|-----|-----------|---------|-------------|
| galaxykate/tracery (reference JS source + readme) | repo | https://github.com/galaxykate/tracery | official | Apache-2.0 | Kate Compton (galaxykate) |
| tracery.io docs site | official-docs | http://tracery.io/ | official | Apache-2.0 | Kate Compton |
| aparrish/pytracery (Python port, tutorials/notebooks) | repo | https://github.com/aparrish/pytracery | community | Apache-2.0 | Allison Parrish |
| tracery-grammar (maintained Node packaging) | repo | https://www.npmjs.com/package/tracery-grammar | community | Apache-2.0 | v25 / community |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.x) | `pip install tracery` | `import tracery; from tracery.modifiers import base_english; g=tracery.Grammar(rules); g.add_modifiers(base_english); print(g.flatten('#origin#'))` |
| JS/TS (Node/browser) | `npm install tracery-grammar` | `const tracery=require('tracery-grammar'); const g=tracery.createGrammar(rules); g.addModifiers(tracery.baseEngModifiers); g.flatten('#origin#')` |
| JS (reference) | `git clone https://github.com/galaxykate/tracery` | Vendor `tracery.js` directly; canonical source, powers Cheap Bots Done Quick |
| JVM/Kotlin | add Maven/Gradle dep from github.com/AlmasB/grammy | Tracery-inspired grammar generator for JVM/games |

## Artifact kind
**text** — output is a flattened plain-text string. The universal text artifact shell renders it directly.

## Validation
- **install:** `pip install tracery`
- **smoke:**
  ```bash
  python -c "import tracery,json; from tracery.modifiers import base_english; r={'origin':'#greeting#, #place#!','greeting':['hello','howdy','hey'],'place':['world','moon','#color# valley'],'color':['green','red']}; g=tracery.Grammar(r); g.add_modifiers(base_english); open('out.txt','w').write('\n'.join(g.flatten('#origin#') for _ in range(5)))" && cat out.txt
  ```
- **expect:** `out.txt` with 5 random expanded lines, e.g. `howdy, green valley!` — no GUI, runs headless on macOS.

## Wrapper params
- **grammar** — the grammar object (symbol -> array of rule strings); the core input.
- **start symbol** — default `#origin#`.
- **samples** — number of lines to generate.
- **seed** — random seed for reproducibility.
- **base_english modifiers** — toggle `.capitalize` / `.a` / `.s` / `.ed`.
- Power features worth surfacing: nesting via `#symbol#` and inline `[key:#rule#]` variable assignment.

## Component / explorer notes
Output is plain text; the default text artifact shell renders it fine. A richer explorer adds value only as a re-roll button (regenerate N samples) plus a grammar/rule editor — neither is required for the deliverable.
