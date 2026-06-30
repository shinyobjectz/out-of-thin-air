# Out Of Thin Air (OOTA)

Author any deliverable — decks, video, audio, diagrams, docs, 3D, games, music,
… — as **deterministic, version-controlled code**, render it headlessly, and
view it in one universal browser shell. **Code-as-X** is OOTA's first capability.

Every artifact reduces to one of **8 render kinds** (`video · audio · pdf ·
image · svg · html · model3d · text`), so one shell renders every medium and a
new tool just maps its output to a kind.

## Quickstart

```bash
oota serve                              # serve on its own nexus (:4010)
oota scaffold diagrams d2 "My diagram"  # wire a session to one tool chain
oota run my-diagram                     # run the chain → out/
oota open my-diagram                    # print the artifact-shell URL
oota help
```

The `oota` CLI is a Bun/TypeScript package in [`oota/`](./oota). OOTA serves on
its **own** nexus — never bundled into a host studio server.

## Layout

| Path | What |
|------|------|
| `oota/` | the `oota` CLI package (bin `oota`) |
| `cli/` | worktop UI + the `oota` HTTP API (`server :oota_api`) |
| `components/artifact/` | the universal artifact shell (renders all 8 kinds) |
| `wrappers/` | one `.work` per tool — controls + render notes |
| `tools/` + `tools/steps/` | host runners; one step script per `<category>-<tool>` |
| `skill/` | agent skill + `skill/catalog/` per-tool dossiers (attributed sources) |
| `eval/` | blind agent scenarios |
| `docs/` | design + research docs (see below) |

## Docs

- [docs/oota-migration.md](docs/oota-migration.md) — the code-as-anything → OOTA rename/repackage.
- [docs/universal-shell-plan.md](docs/universal-shell-plan.md) — the universal artifact shell design.
- [docs/catalog-expansion.md](docs/catalog-expansion.md) — proposed new categories/tools.
- [docs/research-survey.md](docs/research-survey.md) — the original Code-as-X research survey.
