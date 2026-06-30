<!-- generated draft — needs validation -->
# ConTeXt (documents)

## Summary
ConTeXt is a TeX-derived document/typesetting system whose current engine is **LMTX** (LuaMetaTeX). It targets structured documents, fine typography, multilingual layout, and automated PDF production. You author a `.tex`/`.mkxl` source in ConTeXt markup (distinct from LaTeX) and run the `context` CLI to produce a PDF. MetaPost graphics and Lua scripting are embedded. The modern distribution is LMTX (standalone "ConTeXt Suite / minimals") or via TeX Live. No official Anthropic skill exists; the primary driver is the native `context` CLI.

## Skills
| Name | Type | URL | Official | Attribution | License |
|------|------|-----|----------|-------------|---------|
| ConTeXt Garden Wiki | official-docs | https://wiki.contextgarden.net/Main_Page | official | ConTeXt community / Pragma ADE | wiki content (CC-style); software GPL/BSD |
| Pragma ADE manuals (Hans Hagen) | official-docs | https://www.pragma-ade.nl/ | official | Pragma ADE / Hans Hagen | free-to-distribute manuals; engine GPLv2+/BSD |
| context-examples (GUIDE.md) | repo | https://github.com/hmenke/context-examples | community | Henri Menke | see repo |
| context-minimals (reproducible LMTX distro) | repo | https://github.com/usertam/context-minimals | community | usertam | see repo |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Native CLI (LMTX standalone) | `cd ~ && mkdir context && cd context && curl -O https://lmtx.pragma-ade.com/install-lmtx/context-osx-64.zip && unzip context-osx-64.zip && sh ./install.sh && source tex/setuptex` | `context file.tex` |
| Native CLI (TeX Live) | `brew install --cask mactex` (or `brew install texlive`) | `mtxrun --generate` then `context file.tex` |
| Lua (embedded) | included in LMTX | inline via `\startluacode … \stopluacode` / `\ctxlua{…}` (no separate install) |

Notes: sourcing `tex/setuptex` adds `context` and `mtxrun` to PATH. macOS arm64/x86 supported. TeX Live is heavier than the LMTX standalone.

## Artifact kind
**pdf** — primary deliverable is a paged PDF rendered directly by the universal shell's PDF viewer.

## Validation
- **install:** `cd ~ && mkdir -p ctxtest && cd ctxtest && curl -O https://lmtx.pragma-ade.com/install-lmtx/context-osx-64.zip && unzip -o context-osx-64.zip && sh ./install.sh && source tex/setuptex`
- **smoke:** `printf '\\starttext\nHello \\ConTeXt\\ on macOS.\n\\stoptext\n' > hello.tex && context hello.tex`
- **expect:** produces `hello.pdf` in cwd (single-page PDF); exit code 0; log ends with a "finished" line, pages > 0. Verify: `test -f hello.pdf && echo OK`

## Wrapper params
- `documents.title` — document title (text)
- `documents.papersize` — paper size, e.g. A4/letter (select)
- `documents.bodyfont` — body font size, e.g. 10pt/11pt/12pt (select)
- Underlying CLI flags worth exposing: `--result=NAME` (output basename), `--mode=…` (conditional layout modes), `--runs`/`--once` (passes for cross-refs/TOC), `--purgeall` (clean intermediates), `--noconsole`/`--silent` (headless logging). `mtxrun` is the lower-level runner for fonts/scripts.

## Component / explorer notes
Primary deliverable is a PDF — the default artifact shell's PDF viewer renders it directly; no richer explorer needed. The `.tex`/`.mkxl` source is plain text and can be shown alongside.
