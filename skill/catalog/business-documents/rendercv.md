# RenderCV (`rendercv`)

**Category:** business-documents · **Artifact kind:** pdf

## Summary
RenderCV is an open-source (MIT) resume/CV builder that compiles a structured
YAML file into a professionally typeset PDF via the Typst engine. Fully
deterministic and version-controllable: the CV is plain YAML text that diffs
cleanly in git, and rendering is reproducible with no manual layout step.
Primary deliverable is PDF; also emits PNG (per page), HTML, and Markdown from
the same source. Driven entirely from a Python CLI (`rendercv render cv.yaml`),
it runs headless on macOS with no external typesetting binary — Typst ships as a
Python dependency. 17k+ GitHub stars, actively maintained (latest update Jan
2026).

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| rendercv-skill | agent-skill | official | MIT (assumed; same org as core — verify repo LICENSE) | https://github.com/rendercv/rendercv-skill |
| RenderCV JSON Schema | schema | official | MIT | https://docs.rendercv.com/ |

- **rendercv-skill** — RenderCV project (rendercv org). Install:
  `npx skills add rendercv/rendercv-skill`. Lets Claude Code/Desktop, Cursor,
  Codex, Copilot, Windsurf, Gemini CLI and 20+ agents author/edit the CV YAML.
  Advertised on rendercv.com and docs.rendercv.com.
- **RenderCV JSON Schema** — Official JSON Schema bundled with the package
  enables YAML autocompletion + inline docs in editors/agents; primary grounding
  for non-skill agent authoring.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython >= 3.12) | `pip install "rendercv[full]"` | `rendercv new "John Doe"` scaffolds `John_Doe_CV.yaml`; `rendercv render John_Doe_CV.yaml` emits PDF (+ PNG/HTML/Markdown) into `rendercv_output/` |

Sole driver. Typst engine is a bundled Python dependency — no LaTeX, no separate
binary, no network at render time. Headless-clean. Callable from any shell/CI;
the agent skill simply shells out to this same CLI. Use the `[full]` extra to get
PNG/HTML/Markdown renderers, not just PDF.

## Artifact kind
**pdf** — primary deliverable. PNG/HTML/Markdown are secondary outputs from the
same YAML source.

## Validation
- **Install:** `python3 -m venv /tmp/rcv && /tmp/rcv/bin/pip install "rendercv[full]"`
- **Smoke:** `cd /tmp && /tmp/rcv/bin/rendercv new "Test User" && /tmp/rcv/bin/rendercv render "Test_User_CV.yaml"`
- **Expect:** Exit 0; `rendercv_output/Test_User_CV.pdf` created (plus
  `Test_User_CV.png` pages, `.html`, `.md`). Verify with:
  `test -f /tmp/rendercv_output/Test_User_CV.pdf && file /tmp/rendercv_output/Test_User_CV.pdf | grep -q PDF`.
  Runs fully headless on macOS, no GUI/X server.

## Wrapper params
- `business-documents.title` (text) — candidate full name; drives the scaffold
  and output filename.
- Pin `rendercv` to an exact version for reproducible, byte-stable output.
- `--output-folder-name <dir>` controls output dir (default `./rendercv_output`).

## Component / explorer notes
Input contract is a single YAML file with `cv` (content: personal info,
education, experience, projects, etc.) and `design` (theme, fonts, margins,
colors) top-level keys. Five built-in themes (classic, sb2nov,
engineeringresumes, engineeringclasses, moderncv). Deterministic: same YAML +
same rendercv version → byte-stable PDF. Locale/multi-language supported. The
YAML is the version-controlled source of truth — OOTA authors and diffs the
`.yaml`, the PDF is a derived build artifact. Wrap as a thin CLI shell: write/
patch the YAML, run `rendercv render <file> --output-folder-name <dir>`, collect
the PDF (and optional PNG/HTML/MD). For agent-authored flows, prefer grounding on
the bundled JSON Schema (or the official rendercv-skill) so generated YAML
validates before render.
