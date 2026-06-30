# JSON Resume

## Summary
JSON Resume is an open-source standard that defines a JSON Schema (Draft-04) for resume/CV data. You author one deterministic, version-controllable `resume.json` and render it headlessly through swappable community themes (npm packages named `jsonresume-theme-*`) to HTML or PDF. Same JSON + same pinned theme = same output, which fits OOTA's code-to-artifact model exactly. Two CLIs drive it: the modern `resumed` (recommended, MIT) and the original `resume-cli` (revived for Node 18+). The schema has 10 top-level sections: `basics`, `work`, `volunteer`, `education`, `awards`, `certificates`, `publications`, `skills`, `languages`, `references`. All are optional except `basics`. Primary deliverable is PDF; HTML is the intermediate/alternate.

## Skills
- **json-resume** — type: none (no official Anthropic/Claude skill exists), official: false
  - Schema: https://jsonresume.org/schema
  - Docs: https://docs.jsonresume.org
  - License: N/A (standard is open; CLIs/themes are MIT)
  - Attribution: No first-party Anthropic Skill or community Claude-skill repo found as of 2026-06. Integrate directly via the schema + CLI docs. Primary reference is the official schema page and docs.jsonresume.org.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JS/TS (Node >=18) | `npm install -g resumed && npm install jsonresume-theme-even` | `resumed init resume.json`; `resumed validate resume.json`; `resumed render resume.json --theme jsonresume-theme-even --output resume.html`. Recommended (MIT, tested). PDF needs `npm install puppeteer` + `--format pdf`. |
| JS/TS (Node >=18) | `npm install -g resume-cli && npm install jsonresume-theme-even` | `resume init`; `resume validate`; `resume export resume.pdf --theme even` (bundles puppeteer, PDF works out of box); `resume export resume.html`. Heavier but batteries-included. |
| any (npm registry) | `npm install jsonresume-theme-even` | Themes are pluggable npm packages (`jsonresume-theme-*`), each a pure function (resume JSON -> HTML string) — the source of determinism. Examples: `jsonresume-theme-even`, `jsonresume-theme-actual`, `@jsonresume/jsonresume-theme-class`. |

## Artifact kind
**pdf** (primary deliverable). HTML is the intermediate/alternate, zero-dependency render.

## Validation
- **install:** `npm install -g resumed && npm install jsonresume-theme-even`
- **smoke:** `resumed init resume.json && resumed validate resume.json && resumed render resume.json --theme jsonresume-theme-even --output resume.html && test -s resume.html && echo OK`
- **expect:** `resume.json` scaffolded and passes schema validation; a non-empty `resume.html` is emitted fully headless (no GUI/browser). Exit 0 and `OK` printed. For PDF: `npm install puppeteer` then `resumed render resume.json --theme jsonresume-theme-even --format pdf --output resume.pdf` (downloads headless Chromium on first run; macOS arm64/x64 supported). HTML smoke is the reliable zero-dependency check.

## Wrapper params
- `business-documents.title` (text) — render/filename label.
- `business-documents.name` (text) — `basics.name`.
- `business-documents.theme` (select) — pinned theme package, e.g. `jsonresume-theme-even`.
- `business-documents.format` (select html|pdf) — output kind.
- `business-documents.resume_json` (textarea, file-bound to `src/resume.json`) — the deterministic source.

## Component / explorer notes
The deterministic unit is `resume.json` conforming to the JSON Resume schema (Draft-04). Emit valid JSON only; run `resumed validate` as a build gate; **pin a specific theme version** (themes change layout across versions, breaking determinism). All 10 sections optional except `basics`. Dates are ISO-8601 strings. Keep theme choice explicit and pinned in `package.json` so renders reproduce across machines. For headless PDF on macOS/CI, set `PUPPETEER_EXECUTABLE_PATH` at a system Chrome to avoid the ~150MB Chromium download. Prefer `resumed` for HTML-only flows; use `resume-cli` for batteries-included PDF.
