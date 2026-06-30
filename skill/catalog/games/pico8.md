<!-- generated draft — needs validation -->
# pico8 (games)

## Summary
PICO-8 is Lexaloffle's commercial fantasy console. You write Lua game loops (`_init`/`_update`/`_draw`) plus pixel/sound/map data into a `.p8` (or `.p8.png`) cartridge, and the runtime renders a 128x128, 16-color game. Code-as-X angle: the whole game is a single editable Lua/text source file an agent can generate and edit. The native binary (paid, ~$15, not free/OSS) runs the cart and exports stand-alone **HTML+JS web players**, native binaries, GIFs, or PNG cart images. It supports true headless automation: `pico8 -x build.p8` runs a cart with no display/sound/input and exits, and `-export` / the `EXPORT` command runs the exporter headless for CI. PRIMARY agent deliverable = a playable HTML web export (html shell + canvas runtime). Around it is a Python tooling ecosystem (picotool/p8tool, shrinko8) for reading/writing/minifying/format-converting carts without the GUI. No first-party Anthropic/Claude skill exists; the community has documented driving PICO-8 from Claude Code. Confidence: medium — headless flags and Python tools are well-documented, but the smoke test requires the paid binary (not installable via package manager), so validation is gated on owning PICO-8.

## Skills
| Name | URL | Official? | License | Attribution |
|---|---|---|---|---|
| PICO-8 Manual (Lexaloffle) | https://www.lexaloffle.com/pico8_manual.txt | official | proprietary (Lexaloffle docs) | Lexaloffle Games — CLI flags `-x`/`-export`, `EXPORT` command, headless builds |
| PICO-8 API Cheatsheet | https://iiviigames.github.io/pico8-api/ | community | community reference | iiviigames — quick Lua API reference |
| awesome-PICO-8 | https://github.com/pico-8/awesome-PICO-8 | community | CC0/community list | pico-8 org — curated tools/carts/libraries index |
| Code-Vibing with AI: Building a Pico-8 Game | https://lgallardo.com/2025/11/09/pico8-ai-game-development/ | community | blog | lgallardo.com — Claude Code workflow, prose only (no SKILL.md) |
| Claude Code and PICO-8 (BBS thread) | https://www.lexaloffle.com/bbs/?tid=153543 | community | forum | Lexaloffle BBS — LLM-driven cart authoring discussion |

## Toolchains
| lang | install | invoke |
|---|---|---|
| native CLI (PICO-8, paid ~$15) | Purchase + download from https://www.lexaloffle.com/pico-8.php ; install app; ensure `pico8` on PATH (macOS: `/Applications/PICO-8.app/Contents/MacOS/pico8`) | Run: `pico8 cart.p8` · headless run: `pico8 -x cart.p8` · web export: `pico8 cart.p8 -export "game.html"` · multi-cart: `EXPORT FOO.HTML DAT1.P8 ...` |
| Python (picotool / p8tool) | `git clone https://github.com/dansanderson/picotool && python3 setup.py` | `p8tool ...` — read/write `.p8`/`.p8.png`, full Lua parser+AST, gfx/sfx/music/map access without the binary |
| Python (shrinko8) | `git clone https://github.com/thisismypassport/shrinko8` | `python shrinko8.py in.p8 out.p8 --minify` (lint, format-convert p8<->p8.png) · `--count` for token/char/compressed budget |

## Artifact kind
**html** — PICO-8's HTML export is a self-contained html+js+canvas bundle the universal shell can iframe/render directly; it boots the JS runtime and plays the game. A `.p8` source alone is just text; a `.p8.png` is the cart-label image.

## Validation
- **install**: Purchase/install PICO-8 from lexaloffle.com; on macOS symlink the binary: `ln -s /Applications/PICO-8.app/Contents/MacOS/pico8 /usr/local/bin/pico8`. (Optional, no purchase: clone shrinko8 for cart-only ops.)
- **smoke**: `printf '%s\n' 'pico-8 cartridge // http://www.pico-8.com' 'version 42' '__lua__' 'function _draw() cls() print("hi",48,60,12) end' > /tmp/hi.p8 && pico8 /tmp/hi.p8 -export "/tmp/hi.html" && ls -la /tmp/hi.html /tmp/hi.js`
- **expect**: PICO-8 runs headless and writes `/tmp/hi.html` plus `/tmp/hi.js` — a stand-alone web player you can open to see "hi" drawn on the 128x128 canvas. shrinko8-only fallback: `python shrinko8.py /tmp/hi.p8 /tmp/hi_min.p8 --count` prints token/char/compressed counts and writes the minified cart.

## Wrapper params
- `games.title` — cart title.
- `games.export_format` — `html` (web, default), `bin` (native), `png` (cart image), `gif` (clip).
- `games.headless_run` — `-x` execute-and-exit (build/data carts) vs normal run.
- `games.minify` — optional shrinko8 `--minify` pass (token/char budget under PICO-8's 8192-token / compressed-size limits; `--count` reports usage).
- Paths are relative to cwd, not the PICO-8 virtual FS.

## Component / explorer notes
The HTML export embeds cleanly via iframe in the default artifact shell — boots the runtime and plays. A richer explorer (cart gfx/map/sfx tabs) is nice-to-have, not required. Plain `.p8` renders as code; `.p8.png` renders as an image.
