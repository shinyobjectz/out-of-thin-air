# Universal Artifact Shell — Plan

> **Status (P1 shipped):** universal `components/artifact` shell live (header
> collapse · version tabs · Export; Adjust rail + dirty Save changes →
> params/`/adjust` + `file:` source/`/src`); medium-agnostic `artifacts` scanner
> + `artifacts do` override in `api.work`; video/music clients deleted. **Plus**
> the subtree now serves standalone on its OWN nexus (`oota serve` →
> :4010, `CODE_AS_BASE=""`, root-relative URLs), and the studio's `just board`
> excludes `projects/` via the new nexus `WB_IGNORE`. Both modes verified.
> Remaining: P2 (svg/model3d/text kinds, per-version export, named-tab polish).


Goal: one component shell that works for **every** code-as-X medium (deck, video,
audio, PDF, diagram, CAD, game, …), replacing the bespoke `components/video`
client. The compiled workbook surface gets a header (collapse · version tabs ·
export), an Adjust rail with a dirty-aware **Save changes** button, and a
preview stage that swaps renderer by artifact kind. Toolbar can collapse to
preview-only.

---

## 1. Key insight — many mediums, few preview kinds

Every artifact a chain produces reduces to one of **8 render kinds**. The shell
only needs 8 renderers, not 15+ bespoke clients.

| kind | renderer | transport |
|------|----------|-----------|
| `video` | `<video>` | scrubber (reuse `bindVideoTransport`) |
| `audio` | `<audio>` | scrubber (same) |
| `pdf` | `<iframe>` / pdf embed | page nav (native) |
| `image` | `<img>` (png/jpg/webp) | — |
| `svg` | inline `<svg>` / `<img>` | — |
| `html` | `<iframe>` (src or srcdoc) | depends on content |
| `model3d` | `<model-viewer>` (glb/stl) | orbit |
| `text` | `<pre>` | — |

### Medium → tool → output → kind

| category | tools | primary output | kind(s) |
|----------|-------|----------------|---------|
| presentations | marp, slidev, reveal, quarto, deckary | PDF or HTML deck | `pdf`, `html` |
| video | remotion, hyperframes, motion-canvas, manim | MP4 (+ live preview) | `video`, `html` (live) |
| audio | tts-local | WAV/MP3 | `audio` |
| diagrams | mermaid, d2, plantuml, structurizr | SVG/PNG | `svg`, `image` |
| cad | cadquery, openscad, freecad | STL/STEP + render PNG | `model3d`, `image` |
| electronics | skidl, kicad | SVG schematic / gerber | `svg`, `image` |
| documents | typst, latex, context | PDF | `pdf` |
| creative | p5js, threejs, processing | HTML canvas | `html` |
| music | sonic-pi, tone-js, tidal | WAV/MP3 (+ MIDI) | `audio` |
| notation | lilypond | PDF/PNG/SVG + MIDI | `pdf`/`svg` + `audio` |
| fiction | ink, twine, renpy | playable HTML | `html` |
| games | pico8, tic80, love2d | HTML/PNG cart | `html`, `image` |
| typography | fontparts, metafont | font + specimen | `html` |
| textiles | knitout, turtlestitch | SVG preview + machine file | `svg` |
| generative-text | tracery | text | `text` |

Onboarding a new medium = map its output extension to a kind. No new UI.

---

## 2. Generalized artifact contract

Replace the video-specific player payload with a medium-agnostic `artifacts`
list. Each entry is a **version** — tabs map 1:1 to entries.

```
GET /oota/session/player?slug= →
{
  ok, title, slug,
  controls: [ … ],          // unchanged — player.work `controls do`
  params:   { … },          // current values; client uses as dirty baseline
  artifacts: [              // NEW — ordered; each is a selectable version
    { id, label, kind, url, default, live }
  ]
}
```

Derivation in `cli/api.work`:
- **Auto-scan** `out/` for known extensions → kind (mp4→video, wav/mp3→audio,
  pdf→pdf, png/jpg→image, svg→svg, html→html, glb/stl→model3d, txt/md→text).
- **Explicit** `player.work` `artifacts do` block supersedes the scan — lets the
  agent name, order, and group multiple versions:
  ```
  artifacts do
    punchy: { kind: "video", file: "out/punchy.mp4", label: "Punchy cut", default: "true" }
    calm:   { kind: "video", file: "out/calm.mp4",   label: "Calm cut" }
    deck:   { kind: "pdf",   file: "out/slides.pdf", label: "Deck" }
  end
  ```
  (Field values are quoted, same as `controls do`.)
- Remotion live preview stays as an `html` artifact (the `preview-player` iframe),
  marked `live: true`.

"Multiple versions of multiple PDFs/videos/anything" = just multiple `artifacts`
entries. The center tabs enumerate them (named, else 1·2·3).

---

## 3. Universal shell — `components/artifact/index.work` (`client :code_as_artifact`)

One client replaces the per-medium clients. Query: `?slug=` (kind inferred per
active artifact).

```
┌ header ──────────────────────────────────────────────────┐
│ [⟨⟩ collapse]      [ 1 ][ 2 ][ 3 ] …          [ Export ]  │
├──────────┬───────────────────────────────────────────────┤
│ rail     │  stage: renderArtifact(kind, url)             │
│ Adjust   │                                               │
│ controls │                                               │
│ ───────  │                                               │
│ [ Save   │                                               │
│  changes]│                                               │
└──────────┴───────────────────────────────────────────────┘
```

- **Header left — collapse toggle.** Hides the rail (grid col → 0), persisted in
  `localStorage` per slug. Fully collapsed = preview-only (no toolbar).
- **Header center — version tabs.** Enumerated from `artifacts`; label from
  `artifact.label`, fallback to ordinal. Click → swap stage source + kind.
- **Header right — Export.** Run chain + render the deliverable (today's flow).
- **Rail — Adjust.** `UI.renderControls` (unchanged). Bottom: **Save changes**.
- **Stage.** `renderArtifact(kind, url)` switch; video/audio reuse the scrubber.

### Save-state model (replaces "Run chain")

- Track dirty = current params ≠ baseline (set on load + after each save).
- Button states:
  - clean → disabled, label "Saved".
  - dirty → enabled, label "Save changes".
- Click → `POST /oota/session/adjust` (writes params into `player.work` /
  session `params do`) → on ok, baseline = current, back to "Saved".
- **Two distinct verbs:** *Save changes* = persist edits to the code/API the
  workbook generated. *Export* = run + render the final deliverable.

---

## 4. Files to touch

- **NEW** `components/artifact/index.work` + `design.work` — generalize the `cc-`
  shell; add header bar (collapse · tabs · export), Save-changes button.
- `components/lib/ui.js` — add:
  - `renderArtifact(stage, kind, url)` — the 8-kind switch.
  - `initCollapse(shell, rail, btn, key)` — rail collapse + persistence.
  - `renderVersionTabs(headerEl, artifacts, onPick)`.
  - `initSaveState(railFootEl, btn, getParams, baseline, onSave)`.
  - generalize `bindVideoTransport` → works for `<audio>` too (already does).
- `cli/api.work` — add `artifacts` scanner + `player.work` `artifacts do` parser;
  keep `video/videos/compositions` for back-compat during migration.
- `cli/_template/session.work` / player template — add an `artifacts do` example.
- `components/video`, `components/music` — **delete** (universal shell replaces
  both). Update every `[[components/video]]` / `[[components/music]]` doc link.
- `tools/open.sh` + `oota open` verb — point every type at the artifact shell.

---

## 5. Per-medium onboarding workflow (the repeatable recipe)

Per new medium the agent does **only**:
1. Pick category + tool in the chain (auto-routed already).
2. Write code in `out/` that emits a file of a known kind (e.g. typst →
   `out/report.pdf`).
3. *(Optional)* `player.work`: `controls do` (human tweaks) + `artifacts do`
   (name/order versions).
4. `oota open <slug>` → universal shell renders it.

Platform-side, onboarding a medium = add one extension→kind mapping in the
scanner (if not already covered) + a wrapper note. No bespoke client.

---

## 6. Phasing

- **P1** — artifact contract + scanner + universal shell (header: collapse,
  tabs, export) + Save-changes dirty model. Kinds: video, audio, pdf, image,
  html. Migrate video + music. *(This is the bulk of the value.)*
- **P2** — remaining kinds (svg, model3d, text); named tabs from `player.work`;
  per-version export.
- **P3** — multi-artifact composite views (deck + voiceover together); polish.

---

## 7. Decisions (locked)

1. **Save scope = params + source edits.** Save changes persists rail control
   values *and* agent-authored source. A control may declare a `file:` target
   (an `out/src/…` path); on save those write through `POST
   /oota/session/src/save` (already path-guarded to `src/`), while plain
   params write through `/oota/session/adjust`. One Save button, two sinks.
2. **Versions = both, explicit wins.** Auto-scan `out/` by extension; a
   `player.work` `artifacts do` block overrides naming/ordering when present.
3. **Old clients = hard-delete in P1.** Remove `components/video` and
   `components/music`; the universal `components/artifact` shell is the only
   surface. Update `tools/open.sh`, `oota open`, and every doc link in the
   same pass.
4. **Export = whole session.** Export runs the chain + renders the session
   deliverable (today's behavior). The active tab is preview-only.

### Implications of the source-edit decision
- `controls do` entries gain an optional `file:` field. No `file:` → param sink.
  With `file:` → source sink (must resolve under `out/src/`).
- Dirty state tracks both sinks; Save is enabled if *either* changed.
- Keep the existing `safe_session_file` guard (slug + `src/` prefix + no `..`).

## Editing layer (shell infrastructure, NOT catalog)

Rich-text **editor frameworks** — **Plate** (React/Slate), **Lexical** (Meta),
**TipTap** / **ProseMirror**, **Slate** — are GUI-first authoring components, so
they fail the catalog bar (deterministic source → artifact). They are not tools;
they are the candidate **editing layer** for OOTA itself:
- the artifact shell's rich-text controls (a `controls do` field type beyond the
  current contenteditable `.ca-text`), and
- authoring structured-text sources (the `markup` category — MDX/Markdoc) with a
  live WYSIWYG that serializes back to the `.work`/source file.

Markup *formats* (MDX, Markdoc, AsciiDoc, rST) ARE catalog tools (category
`markup`); the *editors* above are how a human edits them in the shell.
Candidate for a later phase; recorded here so the boundary stays clear.
