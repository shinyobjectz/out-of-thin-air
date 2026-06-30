<!-- generated draft — needs validation -->
# Ren'Py (fiction)

## Summary
Ren'Py is an open-source visual-novel / branching interactive-fiction engine. Games are authored in `.rpy` script files (a custom DSL embedding Python) under a project's `game/` directory, declaring labels, characters, dialogue, menus (player choices), and persistent/stateful variables. The engine is itself Python-based and driven entirely via the `renpy.sh` launcher CLI: run a project, lint it, and build distributions (Windows/Mac/Linux/Android/iOS and a WebAssembly HTML5 web export) headlessly. The primary deliverable is an interactive playable game; the most embeddable shell kind is the HTML5/WASM web build. There is no first-party pip package — distribution is the downloadable SDK; the only language you author/drive it from is Python via its DSL.

## Skills
| Name | URL | Official | License | Attribution |
|------|-----|----------|---------|-------------|
| Ren'Py Documentation (Reference Manual) | https://www.renpy.org/doc/html/index.html | official | Ren'Py docs license; engine MIT-style/LGPL components | Ren'Py / Tom Rothamel |
| Ren'Py Command Line Interface docs | https://www.renpy.org/doc/html/cli.html | official | Ren'Py docs | renpy.org |
| Ren'Py Language Basics (.rpy script syntax) | https://www.renpy.org/doc/html/language_basics.html | official | Ren'Py docs | renpy.org |
| renpy/renpy (engine source) | https://github.com/renpy/renpy | official | MIT (engine) + assorted | renpy org |
| renpy/renpyweb (HTML5/WASM web port) | https://github.com/renpy/renpyweb | official | see repo | renpy / Beuc |
| torrentails/RenPy-Script-Builder (authoring helper) | https://github.com/torrentails/RenPy-Script-Builder | community | see repo | torrentails |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Python (Ren'Py SDK, bundled interpreter) | Download SDK from https://www.renpy.org/latest.html (e.g. `renpy-8.3.4-sdk.tar.bz2`), extract. No official PyPI package. | `./renpy.sh <projectdir>` to run; `./renpy.sh <projectdir> lint` to validate; `./renpy.sh launcher distribute <projectdir> --destination <dir>` to build packages headlessly. |

Only supported authoring/driving language is Python. Games are `.rpy` files (DSL embedding Python) plus optional `_ren.py` / `.rpy` Python blocks.

## Artifact kind
`html` — the embeddable form is the HTML5/WASM web build (`index.html` + `web.zip` from renpyweb), runnable in an iframe. The primary artifact is actually an interactive, stateful game; for agent workflows the most reviewable text artifact is the `.rpy` script itself plus the `lint.txt` report.

## Validation
- **install**: `curl -L -o renpy-sdk.tar.bz2 https://www.renpy.org/dl/8.3.4/renpy-8.3.4-sdk.tar.bz2 && tar xjf renpy-sdk.tar.bz2 && cd renpy-8.3.4-sdk`
- **smoke**: `./renpy.sh launcher create_project /tmp/vn_test && ./renpy.sh /tmp/vn_test lint`
- **expect**: `create_project` scaffolds a runnable project at `/tmp/vn_test` (with `game/script.rpy`); `lint` parses all `.rpy` files and prints a report ("No problems found" or a list of issues) to stdout/`lint.txt`, confirming the engine + script DSL work headlessly. To produce a shippable file: `./renpy.sh launcher distribute /tmp/vn_test --destination /tmp/out` builds platform zip/dmg packages; the HTML5 web build produces `web.zip` / `index.html`. Note: distribute/web builds may prompt to download extra platform/web packages on first run, which needs network and is not fully silent.

## Wrapper params
- project directory
- subcommand: `run | lint | create_project | launcher distribute`
- `--destination` for build output
- `--package` to select target platforms (`pc`, `mac`, `linux`, `market`, `android`, `web`)
- web export beta flag
- Author-time knobs in `.rpy`/`options.rpy`: `build.name`, `config.version`, define character voices/styles, label/menu branching.
- For headless CI prefer `lint` (deterministic, no GUI) and pre-download platform packages once to avoid interactive prompts.

## Component / explorer notes
The primary artifact is an interactive, stateful game, not a static file — the default static artifact shell cannot render it. The HTML5/WASM web build (`index.html` + `web.zip`) is the embeddable form and runs in an iframe, but it is heavy (multi-MB WASM runtime) and wants a richer explorer/preview rather than a thumbnail. For agent workflows the most reviewable text artifact is the `.rpy` script itself plus the lint report.
