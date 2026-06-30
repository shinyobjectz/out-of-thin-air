<!-- generated draft — needs validation -->
# deckary (presentations)

## Summary
Deckary ([deckary.com](https://deckary.com)) is a **commercial, closed-source AI add-in for Microsoft PowerPoint**. It generates consultant-grade native `.pptx` slides, charts (waterfall, Mekko, Gantt), icons, and alignment shortcuts from natural-language prompts and pasted data, entirely inside the Office taskpane.

**It is NOT a code-as-X tool.** There is no public CLI, no language SDK, no `SKILL.md` repo, and no headless/scriptable interface. The "oota presentations / syntax-highlighted, exportable technical talks" profile this catalog targets describes a different class of tool — **Marp, Slidev, reveal.js, Marpit** — which Deckary only writes blog comparisons about.

**Confidence: LOW.** The named tool does not fit the code-as-X taxonomy at all. No install command, no smoke test, and no programmatic entrypoint exist to validate. If the intent was a markdown/code-driven deck engine, research **Marp (`@marp-team/marp-cli`)** or **Slidev (`@slidev/cli`)** instead — both are real CLI/Node toolchains with markdown source, syntax highlighting, and headless `.pdf`/`.pptx`/`.html` export.

## Skills
_No code-as-X skill exists for Deckary — it is a proprietary GUI add-in with no scriptable surface._

Attributed references for the **correct** oota presentations tools (use these if a markdown-driven deck is actually wanted):
- **Marp CLI** — https://github.com/marp-team/marp-cli — official (marp-team) — MIT
- **Marp Core / Marpit** — https://github.com/marp-team/marpit — official (marp-team) — MIT
- **Slidev** — https://github.com/slidevjs/slidev — official (slidev) — MIT
- **reveal.js** — https://github.com/hakimel/reveal.js — official (hakimel) — MIT
- Deckary product/blog — https://deckary.com — official (commercial, proprietary) — no OSS license

## Toolchains
| lang | install | invoke |
| --- | --- | --- |
| (Deckary) GUI add-in | Microsoft AppSource / Office add-in store (no package manager) | interactive PowerPoint taskpane only — no CLI |
| fallback: Marp (Node) | `npm i -g @marp-team/marp-cli` | `marp deck.md --pdf` (or `--pptx`, `--html`) |
| fallback: Slidev (Node) | `npm i -g @slidev/cli` | `slidev build` / `slidev export` |

## Artifact kind
**pdf** — the primary deliverable is a native `.pptx` deck, optionally exported to PDF. The universal shell cannot render `.pptx` (binary GUI format), so the scaffold targets a PDF-class deliverable. There is no source/markup to syntax-highlight, contrary to the assumed category.

## Validation
- **install:** N/A — Deckary is a proprietary PowerPoint add-in installed via Microsoft AppSource / the Office add-in store, not a package manager. No npm/pip/cargo/brew package exists.
- **smoke:** N/A — no CLI or scriptable entrypoint; the product runs only interactively inside PowerPoint's taskpane. Cannot produce an output file headless on macOS.
- **expect:** No headless validation possible. Interactive output is a native `.pptx` editable in stock PowerPoint (optionally PDF-exported).
- **fallback smoke (Marp):** `marp deck.md --pdf -o out/deck.pdf` → produces a real PDF headlessly; this is what the step script attempts.

## Wrapper params
No programmatic params exist for Deckary — interaction is entirely via the taskpane (NL prompt, data paste, chart-type picker, brand styling). The wrapper exposes generic deck params (`title`, `subtitle`, `theme`) that bind to the **Marp fallback** source so the step can still degrade gracefully to a real artifact.

## Component / explorer notes
Deliverable is a binary `.pptx` (or PDF export), not a self-rendering web artifact. The default artifact shell cannot render `.pptx`; viewing requires PowerPoint / Keynote / Google Slides, or a PDF export step. This is a closed GUI product — no source/markup to syntax-highlight. The scaffold therefore writes a Marp-markdown source plus a graceful PDF render path.
