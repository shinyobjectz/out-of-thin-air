<!-- generated draft — needs validation -->
# Defold (games / html)

## Summary
Defold is a free, source-available, truly cross-platform game engine (originally by King, now maintained by the Defold Foundation). Games are authored declaratively — collections, game objects, and components live in text-based protobuf files (`.collection`, `.go`, `.gui`) — plus Lua 5.1 gameplay scripts (`.script`/`.lua`). Everything is plain text / protobuf and therefore version-control-friendly. The headless, deterministic build pipeline is `bob.jar` (the "Bob" command-line builder), driven entirely from the JVM with no editor required. For OOTA the primary deterministic, headlessly-renderable deliverable is an HTML5/WASM bundle (platform `wasm-web`): `bob.jar build bundle` emits a self-contained `index.html` + wasm/js/data archive directory that renders in a browser. Native desktop/mobile bundles and a headless engine variant (`dmengine_headless`, `--variant headless`) also exist for CI/automated testing. `bob.jar` currently requires OpenJDK 25.

## Skills
- **No official Anthropic/Claude skill for Defold** — official: no. Searched `anthropics/skills` (https://github.com/anthropics/skills) and the web; none exists. License n/a.
- **Insality/defold-deployer** — community build/deploy CLI wrapper (NOT a Claude skill). https://github.com/Insality/defold-deployer — MIT. Universal bash `build && deploy` script wrapping `bob.jar` (Insality, GitHub).
- **TheKing0x9/defold-builder** — community CLI wrapper. https://github.com/TheKing0x9/defold-builder — see repo for license. Tiny bash script to build/run Defold games from the command line (TheKing0x9, GitHub).

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Java/JVM (bob.jar — primary headless driver, OpenJDK 25) | `brew install --cask temurin@25` then `curl -L -o bob.jar https://github.com/defold/defold/releases/latest/download/bob.jar` (pin a versioned release for reproducibility) | `java -jar bob.jar --archive --platform wasm-web resolve distclean build bundle` (requires existing `game.project`; use `--root` or run from project dir; variants via `--variant debug\|release\|headless`) |
| Lua 5.1 / LuaJIT (embedded in engine, bundled) | none — embedded in Defold runtime | not run standalone; `bob.jar` bytecode-compiles and bundles `.script`/`.lua` into the engine |
| Defold Editor (optional, non-headless; Java/Clojure desktop app) | download from https://defold.com/ | used only to scaffold/create projects interactively; NOT needed for headless CI once a project exists |

## Artifact kind
**html** — HTML5/wasm-web bundle: a self-contained `index.html` plus `<name>_wasm.wasm` + `<name>_asmjs.js` + game data archive that renders the game deterministically in a browser. (Native desktop/mobile binaries and `dmengine_headless` also exist but are not among the 8 OOTA kinds.)

## Validation
- **install**: `brew install --cask temurin@25 && curl -L -o /tmp/bob.jar https://github.com/defold/defold/releases/latest/download/bob.jar && java -jar /tmp/bob.jar --version`
- **smoke** (from root of an existing minimal Defold project containing `game.project` + a main collection/script):
  ```
  cd /path/to/defold-project
  java -jar /tmp/bob.jar --archive --platform wasm-web resolve distclean build bundle
  ls build/default/*/index.html
  ```
- **expect**: bob exits 0 and an HTML5 bundle directory is produced under `build/default/` whose `index.html` (+ `.wasm`/`.js`/`.data` archive) loads and renders the game in a headless Chromium. A minimal project produces byte-stable output for identical inputs.

## Wrapper params
- `games.title` (text) — game/window title written into `game.project`.
- `games.script` (textarea, bound to `src/main/main.script`) — Lua gameplay logic.
- `games.variant` (select: debug/release/headless) — bob build variant.

## Component / explorer notes
Defold projects are version-control-friendly: scenes are text protobuf, config is INI-style `game.project`, logic is plain Lua. Builds are deterministic given a fixed engine version + inputs, making them git-trackable and CI-reproducible. Natural OOTA deliverable kind is `html` (wasm-web bundle). A clean wrapper should: (1) ensure OpenJDK 25 + a pinned `bob.jar`; (2) generate the project skeleton programmatically (write `game.project`, a `main.collection`, and a `main.script` as plain text — no editor needed) to overcome the lack of a CLI "new project" command; (3) run the bundle command; (4) collect `build/default/<name>/` as the html artifact. Pin a specific `bob.jar` release ('latest' drifts). For correctness checks rather than visuals, use `--variant headless` with a native platform + a script that asserts state then exits. Verify the HTML5 bundle renders via Chrome DevTools MCP / puppeteer.
