# games

Fantasy consoles / constrained game dev — pure code loops that build playable carts/games into web-embeddable artifacts.

## BUILD MATRIX

| tool | artifact | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|---|---|---|---|---|---|---|---|
| [pico8](./pico8.md) | html | native CLI (paid pico8), Python (picotool/p8tool, shrinko8) | [PICO-8 Manual (Lexaloffle)](https://www.lexaloffle.com/pico-8.php?page=manual) | yes | ok | yes | yes |
| [tic80](./tic80.md) | html | lua, js, fennel, ruby, wren, squirrel, janet, python (pocketpy), scheme, moon, wasm | [TIC-80 Wiki (nesbox/TIC-80, MIT)](https://github.com/nesbox/TIC-80/wiki) | yes | ok | yes | yes |
| [love2d](./love2d.md) | html | Lua/LuaJIT (native love), JS web export (love.js) | [LÖVE Wiki](https://love2d.org/wiki/Main_Page) | yes | ok | yes | yes |

All three render to `html` (self-contained web players the shell can iframe).

## MULTI-TOOLCHAIN NOTES

- **Python**: pico8 (picotool/p8tool read-write carts, shrinko8 minify); tic80 (pocketpy python target).
- **JS / TS**: tic80 (native js cart language); love2d (love.js → web/JS export).
- **Native**: pico8 (paid binary, headless export), love2d (native `love` runtime + GL/display).
- **Lua**: love2d (LuaJIT, primary), tic80 (default lang), pico8 (Lua dialect).
- **Other langs (tic80 only)**: fennel, ruby, wren, squirrel, janet, scheme, moon, wasm — widest language surface in the category.
- **Go / React**: none in this category.

## VALIDATION ORDER

Cheapest / most-reliable installs first:

1. **love2d** — `brew install --cask love`, free + unrestricted. Caveat: not headless (needs GL/display); CI check is the screenshot file written to the LOVE save dir.
2. **tic80** — `brew install tic80` (verify formula at runtime) or itch.io download / source build. Caveat: FREE official build gates save/export behind PRO; source build exports unrestricted.
3. **pico8** — last: paid (~$15), not in brew/apt. Step graceful-degrades to install hints + optional shrinko8 minify when binary absent.

## EXPLORER NEEDS

All three want a **playable canvas explorer** beyond the default artifact shell — an iframe/embed that runs the exported HTML+JS+canvas game player interactively (input handling, 60fps loop), not just a static preview. pico8 = 128x128 canvas; tic80 = wasm+canvas bundle; love2d = love.js canvas.

## DOSSIERS

- [pico8](./pico8.md)
- [tic80](./tic80.md)
- [love2d](./love2d.md)
