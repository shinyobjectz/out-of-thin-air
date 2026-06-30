<!-- generated draft — needs validation -->

# slidev — presentations

## Summary

Slidev (`@slidev/cli`) is a Vite + Vue 3 tool that turns a single Markdown file (`slides.md`) into an interactive, syntax-highlighted presentation. The primary deliverable is an HTML SPA (`slidev dev` for live serve, `slidev build` for a static `./dist`) with first-class export to PDF/PPTX/PNG/MD via Playwright-Chromium. JS/TS/Node-only toolchain — no Python/Go/Rust bindings. Slide syntax is extended Markdown: `---` frontmatter separators between slides, fenced code blocks (Shiki highlighting), inline Vue components, and Mermaid/PlantUML/LaTeX blocks.

## Skills

| Skill | Type | Official | License | URL |
|---|---|---|---|---|
| slidev-skills (20 Agent Skills) | community | no | MIT | https://github.com/yoanbernabeu/slidev-skills |
| Slidev official docs (LLM-readable) | official-docs | yes | MIT (docs) | https://sli.dev/guide/ |
| create-slidev-presentation | community | no | see repo | https://smithery.ai/skills/AJBcoding/create-slidev-presentation |

- **slidev-skills** — yoanbernabeu. 20 `SKILL.md` skills for Claude Code/Cursor/Windsurf covering quick-start, syntax, layouts, components, code-blocks, magic-move, monaco, mermaid, plantuml, latex, animations, themes, export, deployment.
- **Slidev official docs** — Slidev team. Full guide plus CLI reference at https://sli.dev/builtin/cli and export guide at https://sli.dev/guide/exporting.
- **create-slidev-presentation** — AJBcoding. Community skill to scaffold a Slidev deck.

No official Anthropic skill exists for Slidev.

## Toolchains

| lang | install | invoke |
|---|---|---|
| JavaScript/TypeScript (Node >=18) | `npm install -g @slidev/cli` (or `npm init slidev@latest` to scaffold) | `slidev slides.md` (dev) · `slidev build slides.md` → `./dist` · `slidev export slides.md` → `slides-export.pdf` (needs `npm i -D playwright-chromium`) |
| native CLI (npx, no install) | `npx @slidev/cli@latest` | `npx @slidev/cli export slides.md` |

Only the Node toolchain is supported.

## Artifact kind

**html** — the primary deliverable is an interactive HTML SPA (Vite build → `./dist/index.html`). PDF/PPTX/PNG exports are secondary.

## Validation

- **install**: `npm install -g @slidev/cli playwright-chromium && npx playwright install chromium`
- **smoke**: `printf '# Hello Slidev\n\n---\n\n## Slide Two\n\n```js\nconsole.log(1)\n```\n' > slides.md && slidev export slides.md --output deck.pdf --timeout 60000`
- **expect**: Headless Chromium renders slides and produces a multi-page, syntax-highlighted `deck.pdf` in cwd. Exit code 0. For HTML output use `slidev build slides.md` → `./dist/index.html`. Works headless on macOS.

## Wrapper params

- `presentations.title` — deck title (text)
- export format — `--format pdf|png|pptx|md`
- `--output` — output path
- `--range` — page range
- `--dark` — dark theme toggle
- `--with-clicks` — one page per click animation
- `--timeout` / `--wait` — render stability
- `theme:` frontmatter — theme selection
- `--base` + `./dist` — build path for hosting

Export requires `playwright-chromium` installed in the project.

## Component / explorer notes

The default artifact shell can render the built `./dist/index.html` directly, including Shiki code highlighting and click animations (keyboard/space to advance). For a static, no-JS preview the PDF export embeds slides as pages. A richer explorer is not required, but full interactivity (presenter mode, drawings, Monaco editor) needs the live `slidev dev` server, not a static shell.
