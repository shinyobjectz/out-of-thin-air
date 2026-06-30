<!-- generated draft — needs validation -->
# Twine (fiction / interactive fiction)

## Summary
Twine is the open-source tool for telling interactive, nonlinear, branching stories. Authors write in **Twee** (human-readable text markup) and/or the Twine 2 visual editor; a compiler combines passages plus a **story format** (Harlowe, SugarCube, Snowman, Chapbook) into a single self-contained, playable **HTML** file. The primary deliverable is that one `.html` — all JS/CSS/story data inlined, runs in any browser with no server.

There is **no official Anthropic/Claude skill** for Twine. Headless/CI toolchains are the native Go CLI (Tweego), a JS/Node package (Extwee), and a Ruby gem (Twee2).

> Note: the PyPI package named `twine` is the unrelated Python package-upload utility. There is **no** first-party Python Twine library.

## Skills (attributed references)
| Name | Type | URL | Official | License / Attribution |
|---|---|---|---|---|
| Twine docs / wiki + Twine Cookbook | official-docs | https://twinery.org/cookbook/ | yes | CC (docs) — Interactive Fiction Technology Foundation (IFTF) / twinery.org |
| twine-specs (Twee 3 spec, story-format output spec) | repo | https://github.com/iftechfoundation/twine-specs | yes | see repo (IFTF) |
| Tweego documentation | official-docs | https://www.motoslave.net/tweego/docs/ | yes | docs by Thomas Michael Edwards (tmedwards) |
| Tweego source | repo | https://github.com/tmedwards/tweego | community | tmedwards |
| (No known Anthropic/Claude SKILL.md or llms.txt for Twine) | community | — | no | None found as of research date |

## Toolchains
| lang | install | invoke |
|---|---|---|
| Go (native CLI) — **canonical** | Download precompiled binary from https://www.motoslave.net/tweego/, unzip, keep bundled `storyformats/` alongside (or set `TWEEGO_PATH`); or `go install github.com/tmedwards/tweego@latest` | `tweego -f harlowe-3 -o play.html story.twee` ; list: `tweego --list-formats` ; decompiles HTML→Twee too |
| JS / TypeScript / Node | `npm i extwee` | Twee→HTML compiler + HTML→Twee decompiler. Programmatic API (Story/Passage objects: `toTwee()`, `toTwine2HTML()`, `toJSON()`) + CLI binary. Best for scripting/bots. Not an authoring tool. |
| Ruby | `gem install twee2` | `twee2 build source.twee output.html` — Twine 2 compiler minus GUI; older/less maintained but works |
| GUI / desktop + web (authoring) | Download from https://twinery.org/ or web app https://twinery.org/2/ | Visual passage-map editor; exports the same self-contained HTML. Use Tweego/Extwee for headless/CI. |

## Artifact kind
**html** — single self-contained `.html` with all JS/CSS/story data inlined. Renders directly in the universal HTML shell; interactive link-clicking and state work out of the box, no server/assets.

## Validation
**Install:** Download the Tweego binary for macOS from https://www.motoslave.net/tweego/, unzip, `chmod +x tweego`, ensure the bundled `storyformats/` dir is alongside it (or set `TWEEGO_PATH`).
**Verify:** `./tweego --version` and `./tweego --list-formats`
**Smoke:**
```bash
printf ':: Start\nHello, [[World]].\n\n:: World\nYou made it.\n' > story.twee && ./tweego -f harlowe-3 -o play.html story.twee
```
**Expect:** exit 0 and a self-contained `play.html` (no errors). Opening it shows the `Start` passage with a clickable `World` link that navigates to the second passage. Headless check: `grep` for `tw-storydata` or the passage text in `play.html` to confirm story data was embedded.

## Wrapper params
- `-f` / `--format` — story format + version (`harlowe-3`, `sugarcube-2`, `snowman`, `chapbook-1`). Drives runtime feature set; mandatory in practice.
- `-o` — output filename.
- `--list-formats` — enumerate installed formats.
- input — one or more `.twee` files or a directory (Tweego globs them).
- `TWEEGO_PATH` env var — locates the story formats dir.
- Extwee equivalent: `compile(twee, storyFormat)` API plus the HTML→Twee decompile path.
- Format choice: Harlowe = beginner/macros; SugarCube = heavy state/save systems; Snowman = raw JS/CSS authors; Chapbook = clean prose-first.

## Component / explorer notes
The default HTML artifact shell renders the deliverable directly — Tweego/Extwee emit a single self-contained `.html` that runs in any iframe/browser with no server or external assets; link-clicking and state work out of the box. A richer "explorer" (visual passage graph) is nice-to-have for authoring only, not for playback.
