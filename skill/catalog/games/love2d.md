<!-- generated draft — needs validation -->
# love2d (games)

## Summary
LÖVE (love2d) is a free, open-source 2D game framework for Lua. A game is a folder containing `main.lua` with `love.load` / `love.update(dt)` / `love.draw` callbacks; the `love` runtime bundles LuaJIT, so no separate Lua install is needed. The primary deliverable is an interactive 2D game. It runs natively via the `love` CLI and can be compiled to a playable web build (WASM + HTML + JS) via `love.js` — so **html** is the best artifact-shell match (interactive playable embed). For static dossiers, gameplay is captured as screenshots (`love.graphics.captureScreenshot` → PNG) or screen recording (→ video). love2d is a favored target for LLM/agent codegen because games are 100% code, text-serialized, and well represented in training data.

## Skills
| Skill | Type | Official | License | URL |
|---|---|---|---|---|
| love-font (font/typography in LÖVE) | community | no | unverified | https://mcpmarket.com/tools/skills/l-ve-font-text-styling |
| Lua (mindrally; game-dev section: loops/collision/state) | community | no | unverified | https://crossaitools.com/skills/mindrally/skills/lua |
| LÖVE Wiki (canonical API reference) | official-docs | yes | docs CC-licensed; engine zlib/libpng | https://love2d.org/wiki/Main_Page |

## Toolchains
| lang | install | invoke |
|---|---|---|
| Lua (bundled LuaJIT) | `brew install --cask love` (macOS) / `sudo add-apt-repository ppa:bartbes/love-stable && sudo apt-get install -y love` | write `main.lua` in a folder; `love /path/to/gamedir` |
| native CLI (love binary) | `brew install --cask love` | `love game.love`; macOS binary at `/Applications/love.app/Contents/MacOS/love`. Package: `zip -9 -r game.love .` from game dir |
| JS/TS web export (love.js, Node + Emscripten) | `npm install -g love.js` | `love.js game.love out_dir -c -t MyGame` → `index.html` + WASM + JS |

## Artifact kind
**html** — the love.js web export (HTML + WASM canvas) renders as an interactive playable embed in the universal shell. Non-interactive fallbacks: PNG screenshot (image) or screen recording (video).

## Validation
- **install:** `brew install --cask love` (provides `/Applications/love.app/Contents/MacOS/love`)
- **smoke:**
  ```bash
  mkdir -p /tmp/lovesmoke && printf 'function love.load() love.window.setMode(320,240) end\nfunction love.draw() love.graphics.print("hello love2d", 100, 110) end\nfunction love.update() if love.timer.getTime() > 0.5 then love.graphics.captureScreenshot("shot.png"); end end\nfunction love.keypressed() love.event.quit() end\n' > /tmp/lovesmoke/main.lua && /Applications/love.app/Contents/MacOS/love /tmp/lovesmoke; ls "$HOME/Library/Application Support/LOVE/lovesmoke/shot.png"
  ```
- **expect:** A 320x240 window opens showing "hello love2d"; `captureScreenshot` writes `shot.png` into the LOVE save dir (`~/Library/Application Support/LOVE/<identity>/`). NOT truly headless — love needs an OpenGL context / display. On a headless box without a display this fails; run on a logged-in GUI session. For CI, screenshot capture is the file-producing check.

## Wrapper params
- `games.title` — window title (love.conf `t.window.title`)
- game directory or `.love` archive path
- `games.width` / `games.height` — window size (`t.window.width/height`)
- `games.fps` / vsync — target framerate
- fullscreen flag
- identity (`love.filesystem.setIdentity`) — controls save/screenshot dir
- love.js export: memory size, canvas size, standalone-HTML wrap toggle
- headless: `t.window=false` disables window, but GL-dependent draw/screenshot still needs a display.

## Component / explorer notes
The default artifact shell can render the love.js web export (HTML + WASM canvas) as an interactive playable embed — the richest faithful representation. A plain text/image shell cannot convey interactivity. For non-interactive contexts, capture frames via `love.graphics.captureScreenshot` (PNG → image) or screen-record gameplay (→ video). A richer explorer (canvas + keyboard/gamepad input forwarding + fullscreen) is preferable to the default shell.
