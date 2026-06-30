<!-- generated draft — needs validation -->
# tic80 (games)

## Summary
TIC-80 is a free/open-source fantasy console (`nesbox/TIC-80`) for making tiny
games. You author a single cart with `TIC()` (plus optional `BOOT`/`BDR`/`OVR`)
callbacks — the game loop — in one of ~10 embedded scripting languages, and the
runtime caps you to a 240x136 16-color display, a 256-tile sheet, and 4-channel
sound. It runs as a desktop app OR headless via `tic80 --cli`, which behaves like
a compiler: `load` a cart (plain `.lua`/`.js` text or a `.tic` binary) and
`export` to a self-contained playable HTML bundle, native executables
(win/linux/mac/rpi), PNG sprites, GIF, or WAV audio. The primary deliverable for
a code-as-X pipeline is the exported playable HTML — a browser-runnable game —
so artifact kind is `html`.

CAVEAT (medium confidence): the official itch.io release build is FREE to run/play
but historically requires the PRO version ($) to SAVE/EXPORT carts and to use an
external code editor. Building from source (cmake) yields an unrestricted binary
that exports freely. Homebrew `tic80` formula availability/version should be
verified at runtime.

## Skills (attributed references)
| Skill | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| TIC-80 Wiki | official-docs | https://github.com/nesbox/TIC-80/wiki | yes | MIT (repo) | nesbox/TIC-80 |
| Command-line arguments | official-docs | https://github.com/nesbox/TIC-80/wiki/Command-line-arguments | yes | MIT | nesbox/TIC-80 |
| Supported Languages | official-docs | https://github.com/nesbox/TIC-80/wiki/supported-languages | yes | MIT | nesbox/TIC-80 |
| API reference | official-docs | https://github.com/nesbox/TIC-80/wiki/API | yes | MIT | nesbox/TIC-80 |
| TIC-80 The Missing Manual | community | https://hub.xpub.nl/sandbot/PrototypingTimes/tic80-manual.html | no | unknown | community / XPUB |
| TIC-80 Cheat Sheet | community | https://skyelynwaddell.github.io/tic80-manual-cheatsheet/ | no | unknown | skyelynwaddell |

## Toolchains
| lang | install | invoke |
|---|---|---|
| Lua (default, 5.3) | `brew install tic80` or build from source | no `script` tag; `tic80 --cli --fs . --cmd "load game.lua & export html out.zip & exit"` |
| JavaScript (ES2020, quickjs) | `brew install tic80` | metadata comment `// script: js`; same `TIC()` loop |
| MoonScript | `brew install tic80` | `-- script: moon` |
| Fennel (1.5.0) | `brew install tic80` | `;; script: fennel` (lisp compiling to Lua) |
| Ruby (mRuby 3.0) | `brew install tic80` | `# script: ruby` |
| Wren (0.4.0) | `brew install tic80` | `// script: wren` |
| Squirrel | `brew install tic80` | `// script: squirrel` |
| Janet (1.31.0) | `brew install tic80` | `# script: janet` |
| Python (pocketpy subset) | `brew install tic80` | `# script: python` (not CPython) |
| Scheme (s7) | `brew install tic80` | `; script: scheme` |
| WASM (Rust/C/Zig/tinygo) | `brew install tic80` | advanced: compile to a `.wasm` cart; only embedded scripting langs drive tic80 directly |

## Artifact kind
**html** — primary deliverable is an exported self-contained HTML bundle
(`index.html` + `tic80.wasm`/`.js`) that plays the cart in a browser.

## Validation
- **install**: `brew install tic80` — fallback: download release from
  https://nesbox.itch.io/tic80, or build unrestricted from source:
  `git clone --recursive https://github.com/nesbox/TIC-80 && cd TIC-80/build && cmake .. && make`
- **smoke**:
  ```
  printf 'function TIC()\n cls(13)\n print("HELLO",84,64)\nend\n' > /tmp/hello.lua \
    && tic80 --cli --fs /tmp --cmd "load hello.lua & export html /tmp/hello.zip & exit"
  ```
- **expect**: headless run (no window with `--cli`) writes `/tmp/hello.zip` — a
  self-contained HTML bundle that plays the cart in a browser. NOTE: a FREE
  official build may refuse save/export ("PRO feature"); a source-built binary
  exports without restriction. Swap `export html` for `export mac out.app`,
  `export sprites s.gif`, etc., for other artifacts. Always chain `& exit` so the
  process terminates.

## Wrapper params
- `script` language tag (lua|js|fennel|ruby|wren|squirrel|janet|python|scheme|moon).
- `export` target (html|win|linux|mac|rpi|sprites|map|track|sfx).
- `--cli` (headless), `--skip` (skip intro), `--fs <dir>` (sandbox FS root),
  `--scale`.
- `--cmd` console-script string with `&`-separated commands
  (`load … & export … & exit`).
- Cart source authored as plain `.lua`/`.js` text and `load`ed directly — no
  binary `.tic` needed.

## Component / explorer notes
The primary deliverable (exported HTML zip) is a runnable game, not a static
asset. The default artifact shell can iframe/host the unzipped `index.html`, but
a proper play experience wants a richer explorer: serve the bundle over HTTP (it
loads a `.wasm`), give the canvas focus + keyboard capture, and a fullscreen
toggle. A bare image shell will not run it — treat it like an interactive HTML5
game embed. The cart source itself is plain text and shows fine as a code block.
