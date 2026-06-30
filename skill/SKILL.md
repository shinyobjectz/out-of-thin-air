---
name: oota anything
description: >-
  Routes Code-as-X requirements to categories and polyglot tool chains. Reads
  catalog and router .work files, creates session.work files, drives the code-as
  worktop, and runs local step scripts. Use for presentations, video, diagrams,
  CAD, documents, or any programmatic media — or when the user mentions code-as,
  oota anything, or Code-as-X.
disable-model-invocation: true
---

# Code as Anything (code-as)

Packaged with the project at `projects/oota anything/`. Turn requirements
into **deterministic, version-controlled media** via `.work` sessions and local
polyglot toolchains.

## CLI context (read first)

Paths below are relative to **this project root** (`projects/oota anything/`).

| Where you are | How to run |
|---------------|------------|
| **Inside this project** (local `Justfile` present) | `just run <slug>`, `just render <slug>`, `just hardware`, `just models …` |
| **Monorepo root** (`Apps/shinyobjectz/`) | `oota run <slug>`, `oota render <slug>`, etc. |

If unsure: run `just --list`. Portable verbs are short; monorepo verbs are prefixed `code-as-`.

## Hard rules

1. **`.work` is source of truth** — `projects/oota anything/cli/sessions/<slug>/session.work`
2. **Route before build** — read requirements, call route API or read `cli/router.work`
3. **Progressive disclosure** — catalog → wrapper → step script; one category at a time
4. **Skill lives in the project** — this file, not `~/.cursor/skills/`
5. **Video = full Remotion** — no bash templates; read [remotion-dev/skills](https://github.com/remotion-dev/skills) and write `out/src/*.tsx` yourself

## Workflow

### 1. Route requirements

```bash
# With the standalone code-as nexus running (oota serve → :4010):
curl -s -X POST http://localhost:4010/code-as/route \
  -H 'content-type: application/json' \
  -d '{"requirements":"technical talk deck and architecture diagram","title":"My talk"}'
```

Or read `projects/oota anything/cli/router.work` + `cli/catalog.work`.

### 2. Create session

```bash
oota new "Session title"   # auto-routes if requirements in modal
oota admin                 # session routing CLI (agents)
```

Write/sync `chain do`, `params do`, `## Requirements` in `session.work`. When ready for the user:

```bash
oota open <slug>   # prints the browser URL (run `oota serve` first)
```

### 3. Run

From monorepo root:

```bash
oota run <slug>   # status: running → done (or back to chaining on error)
oota render <slug> # npm install + remotion render → out/*.mp4 (video sessions)
```

From `projects/oota anything/` alone (portable Justfile):

```bash
just run <slug>
just render <slug>
just hardware
just models list tts
```

Outputs land in `cli/sessions/<slug>/out/`.

**Component surface** — what users see in the browser (served by the nexus):

```bash
oota serve       # serve THIS subtree's own nexus on :4010 (never the studio's)
oota open <slug> # prints the artifact-shell URL for the browser
oota admin       # session routing CLI (agents only)
```

One universal shell (`components/artifact/`) renders every medium — it
auto-detects artifact kinds from `out/`. Agent writes `out/` + optional
`player.work` (`controls do`, `artifacts do`), then invokes
`oota open <slug>` and opens the printed URL.

**Component UI:** [Basecoat UI](https://basecoatui.com/) + `components/lib/ui.js`. No native
selects, range inputs, checkboxes, or media controls in surfaces — use custom scrubbers,
Basecoat selects, resizable sidebar, etc. See `components/index.work`.

### Media one-time setup

Monorepo: `oota tts-setup`, `oota models download kokoro-tts`  
Portable: `just tts-setup`, `just models download kokoro-tts`

Without setup, macOS falls back to `say` for voiceover. See [references/agent-ergonomics.md](references/agent-ergonomics.md).

## Key paths

| Path | Purpose |
|------|---------|
| `skill/SKILL.md` | This skill |
| `cli/router.work` | Auto-routing keyword rules |
| `cli/catalog.work` | All categories + tools |
| `cli/sessions/<slug>/session.work` | Active session |
| `components/artifact/` | Universal invokable shell (all mediums) |
| `components/lib/ui.js` | Shell primitives (renderArtifact, tabs, save-state) |
| `wrappers/<cat>-<tool>.work` | Controls + failure modes |
| `tools/run.sh` | Run a session chain |
| `tools/steps/` | Per-tool step scripts |
| `media/models.work` | Local HF model catalog (TTS, music, optional video) |
| `media/libraries.work` | Remocn, remotion-dev/skills, oota music libs |

## Media (Remotion-first)

Video = write **full Remotion** in `cli/sessions/<slug>/out/src/`. CLI handles
session data, voice WAV, hardware, HF models, render — not your compositions.

1. Read [remotion-dev/skills](https://github.com/remotion-dev/skills) and [references/remotion.md](references/remotion.md)
2. `just run <slug>` (portable) or `oota run <slug>` (monorepo) — shell + assets; **never overwrites existing `out/src/`**
3. Write/edit TSX in `cli/sessions/<slug>/out/src/`; optional [Remocn](https://github.com/Remocn/remocn)
4. `just render <slug>` or `oota render <slug>`
5. Optional: `cli/sessions/<slug>/player.work` — user-facing controls only (narration, theme). Pipeline params stay in `session.work`. See `_template/player.work`.

Local voice/music: `just hardware` / `just models list tts` (or `code-as-*` from monorepo).

See [references/media-stack.md](references/media-stack.md).

## Eval

Blind POC tests — portable: `just eval list|reset|prompt|run|score <scenario>`; monorepo: `oota eval …`. See `eval/index.work`.

## References

- [references/session-format.md](references/session-format.md)
- [references/routing.md](references/routing.md)
- [references/verbs.md](references/verbs.md)
- [references/remotion.md](references/remotion.md)
- [references/agent-ergonomics.md](references/agent-ergonomics.md)