<!-- generated draft — needs validation -->
# marp (presentations)

## Summary
Marp (Markdown Presentation Ecosystem) turns Markdown into slide decks. The core
engine is Marpit; the driver is **marp-cli** (`@marp-team/marp-cli`), which converts
a single `.md` into HTML, PDF, PPTX, PNG/JPEG, and speaker-notes TXT. The primary
deliverable is a self-contained, reveal-style **HTML** deck with embedded CSS/JS and
keyboard navigation. PDF/PPTX/image export shells out to a headless
Chromium/Edge/Firefox. YAML front-matter directives control theme, pagination, and
size. Strong fit for technical/code talks: built-in syntax highlighting, themes,
custom CSS, math (KaTeX), and Mermaid via plugin.

## Skills
| Skill | Type | URL | License | Attribution |
|---|---|---|---|---|
| marp-team/marp-cli (official repo + docs) | official-docs | https://github.com/marp-team/marp-cli | MIT | Marp Team |
| marp.app official site / docs | official-docs | https://marp.app/ | MIT | Marp Team |
| robonuggets/marp-slides (Claude Code skill, SKILL.md + 22 example decks, SVG charts, themes) | community | https://github.com/robonuggets/marp-slides | see repo (check LICENSE) | robonuggets |
| eruto-skills/marp (create/edit/theme/convert/summarize, layout patterns) | community | https://github.com/eruto-skills/marp | see repo | eruto-skills |
| softaworks/agent-toolkit marp-slide skill (7 themes, structure best-practices) | community | https://github.com/softaworks/agent-toolkit/blob/main/skills/marp-slide/README.md | see repo | softaworks |
| zl190/md-slides (MD→Slides skill, EN/zh templates) | community | https://github.com/zl190/md-slides | see repo | zl190 |
| ks6088ts-labs/skills marp-slide-creator SKILL.md | community | https://github.com/ks6088ts-labs/skills/blob/main/skills/marp-slide-creator/SKILL.md | see repo | ks6088ts-labs |

Primary skill: **marp-team/marp-cli** (official, MIT) — https://github.com/marp-team/marp-cli

## Toolchains
| lang / runtime | install | invoke |
|---|---|---|
| JS/TS (Node) — primary CLI | `npm install -g @marp-team/marp-cli` | `marp deck.md -o out.html` (or `--pdf` / `--pptx` / `--images png`); one-shot `npx @marp-team/marp-cli@latest deck.md` |
| JS/TS library (Node) | `npm install @marp-team/marp-core` | `new Marp().render(markdown) -> {html, css}` — embed in custom build pipelines |
| native CLI (macOS/Linux) — Homebrew | `brew install marp-cli` | `marp deck.md --pdf` |
| native CLI (Windows) — Scoop | `scoop install marp` | `marp deck.md --pptx` |
| container (any lang) — Docker | `docker pull marpteam/marp-cli` | `docker run --rm -v $PWD:/home/marp/app marpteam/marp-cli deck.md --pdf` (bundles Chromium) |
| standalone binary — prebuilt | download from https://github.com/marp-team/marp-cli/releases | `marp deck.md -o out.html` (no Node; still needs a browser for PDF/PPTX/image) |

## Artifact kind
**html** — the default output is a standalone HTML slide deck (embedded CSS/JS,
keyboard nav). The universal HTML shell renders it directly. PDF/PPTX/image outputs
are optional alternate formats that require the pdf/file shells, not the html one.

## Validation
- **install**: `npm install -g @marp-team/marp-cli`  (or `npx @marp-team/marp-cli@latest`)
- **smoke**:
  ```bash
  printf -- '---\nmarp: true\n---\n# Hello Marp\n\n- bullet one\n- bullet two\n\n---\n\n## Slide 2\n```js\nconsole.log(1)\n```\n' > deck.md \
    && npx @marp-team/marp-cli@latest deck.md -o deck.html
  ```
- **expect**: Writes `deck.html` (a self-contained 2-slide deck; no browser needed
  for HTML). For PDF instead, add `--pdf` (or `-o deck.pdf`) — requires
  Chrome/Edge/Firefox installed; on macOS marp auto-finds Google Chrome. Exit code 0
  and the output file present = success.

## Wrapper params
Key knobs to expose:
- **output format**: `--pdf` | `--pptx` | `--pptx --pptx-editable` | `--images png|jpeg` | `--html`
- **theme**: `--theme` / `--theme-set` (custom CSS)
- **--allow-local-files**: needed for local images in PDF export
- **-o**: output path
- **modes**: `-w` watch, `-s` server/preview, `--no-stdin`
- **front-matter directives**: `marp: true`, `theme`, `paginate`, `size: 16:9|4:3`, `header`, `footer`

Editable-text PPTX (`--pptx-editable`) and PDF/image export all require a headless
Chromium/Edge/Firefox; `CHROME_PATH` env pins the browser.

## Component / explorer notes
The primary artifact is an HTML slide deck — the default HTML shell renders it
directly (standalone page, embedded CSS/JS, keyboard nav). A richer explorer is
optional: a slide-aware iframe wrapper with prev/next + fullscreen improves UX but is
not required. PDF/PPTX outputs need the pdf/file shells, not the HTML one.
