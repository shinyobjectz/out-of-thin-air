<!-- generated draft — needs validation -->
# ChoiceScript (fiction)

## Summary
ChoiceScript (`dfabulich/choicescript`) is a JavaScript-based DSL + interpreter for multiple-choice / branching interactive fiction with persistent variables and stat tracking. Games are authored as plain-text `*.txt` scene files (`startup.txt`, `scenes/*.txt`) written in the ChoiceScript language (`*choice`, `*if`, `*set`, `*goto`, `*gosub`, `*temp`, `*create`). The interpreter is pure JS, runs in-browser, and the toolchain is Node-driven. The primary deliverable is a single self-contained HTML page bundling interpreter + game, playable offline in any browser.

License: ChoiceScript License v1.0 — free for non-commercial use/modification; commercial use requires a license from Choice of Games (support@choiceofgames.com). Confidence: medium — the git-clone + node workflow is well documented; the third-party `choicescript` npm package's exact CLI surface was not directly verifiable (npm 403).

## Skills
| Name | URL | Type | License | Attribution |
|------|-----|------|---------|-------------|
| Choice of Games — Make Your Own Games / ChoiceScript Intro | https://www.choiceofgames.com/make-your-own-games/choicescript-intro/ | official-docs | proprietary docs | Choice of Games LLC |
| dfabulich/choicescript (official interpreter + tooling) | https://github.com/dfabulich/choicescript | repo (official) | ChoiceScript License v1.0 (non-commercial; commercial requires license) | Dan Fabulich / Choice of Games LLC |
| dfabulich/choicescript Wiki (language reference) | https://github.com/dfabulich/choicescript/wiki | repo (official) | docs per repo | Choice of Games community |
| ChoiceScript IDE (browser editor + bundled interpreter + tests) | https://choicescriptide.github.io/ | community | open-source (see repo) | CJ Sharp / choicescriptide |
| ChoiceScript Wiki (Fandom) — Development Tools | https://choicescriptdev.fandom.com/wiki/Development_Tools | community | CC-BY-SA | Fandom community |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/Node (canonical) | `git clone https://github.com/dfabulich/choicescript.git && cd choicescript` | Edit `web/mygame/scenes/*.txt`; `node compile.js mygame > game.html`; test `node quicktest.js` / `node randomtest.js`; serve `node serve.js`. No npm install — interpreter is vendored JS. |
| JavaScript/Node (npm wrapper, unverified) | `npm install -g choicescript` | `choicescript quicktest`, `choicescript randomtest`, `choicescript -h` (third-party; CLI surface unverified — prefer the git repo). |
| Browser / no-runtime | open `web/index.html` after extracting the repo zip | `compile.html` produces the standalone game HTML with no server; pure client-side play/dev. |

## Artifact kind
`html` — a self-contained playable single-page app (interpreter + bundled scenes), rendered directly in an iframe/HTML viewer.

## Validation
- **Install:** `git clone https://github.com/dfabulich/choicescript.git && cd choicescript`
- **Smoke:** `node compile.js mygame > /tmp/mygame.html && ls -la /tmp/mygame.html`  (alt: `node quicktest.js` for the bundled sample game)
- **Expect:** `compile.js` emits a single self-contained HTML file (interpreter + game) that opens and plays in any browser; `quicktest.js` exits 0 and prints PASSED for the sample game. The repo ships a working sample game at `web/mygame/`, so compilation succeeds out of the box with only Node installed.

## Wrapper params
- Game directory / scene-file set (`startup.txt` + `scenes/*.txt`).
- Compile target (single-file HTML vs served).
- Test mode: `quicktest` (deterministic path coverage) vs `randomtest` (randomized playthroughs).
- Randomtest iteration count + RNG seed (reproducibility), verbose/coverage flag.
- License gate: output is non-commercial unless a Choice of Games commercial license is held.

## Component / explorer notes
Primary artifact is a playable HTML game; the default HTML artifact shell renders it directly (interactive SPA, not a static doc). A richer explorer (scene-graph / variable-state inspector / choice-tree visualizer) would add value for authors but is not required to play the output.
