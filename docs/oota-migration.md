# OOTA Migration — oota anything → Out Of Thin Air

Rename + repackage `oota anything` into **OOTA** (Out Of Thin Air): the
umbrella product. "Code-as-X" stays as the *first capability*, but the product,
CLI, routes, and paths become `oota`. Decisions (locked):

1. **Own repo, vendored via git subtree** — OOTA lives at
   `github.com/shinyobjectz/out-of-thin-air`; the monorepo pulls it in at
   `projects/out-of-thin-air` via `git subtree`.
2. **Real `oota` CLI = Bun/TypeScript npm package** (bin: `oota`), flat verbs.
3. **Flat now, modularize later** — keep today's layout; defer carving a
   `modules/code-as/` boundary until sibling systems are concrete.

## Token rename map

| from | to | where |
|------|----|-------|
| `oota anything` (path/product) | `out-of-thin-air` | paths, prose |
| `/code-as/<route>` (HTTP routes) | `/oota/<route>` | `api.work` defs + all client `fetch` + `route.sh` |
| `client :code_as`, `:code_as_artifact` | `:oota`, `:oota_artifact` | clients |
| `server :code_as_api` | `:oota_api` | api |
| `design :code_as*` | `:oota*` | designs |
| `CODE_AS_BASE` / `code_as_base` | `OOTA_BASE` / `oota_base` | api + Justfiles, default `projects/out-of-thin-air` |
| `oota <verb>` | `oota <verb>` (package) | CLI |

`<category>-<tool>` wrapper/step filenames are unaffected. "Code-as-X" as a
*concept* may remain in prose.

## Stages

- **A — Rename/restructure (in monorepo):** `mv` dir → `out-of-thin-air`; sweep
  tokens; update root Justfile + AGENTS.md; verify the standalone nexus serves
  `/oota/*` + the artifact shell.
- **B — `oota` CLI package:** Bun/TS package under the subtree (`oota/`), bin
  `oota`, flat verbs (`serve new scaffold run open render route hardware models
  eval`) wrapping the existing `tools/*.sh` + nexus serve. Publishable to npm.
- **C — Repo split (DONE):** OOTA is its own git repo, pushed to
  `github.com/shinyobjectz/out-of-thin-air` (`main`), living as a **nested
  standalone clone** at `projects/out-of-thin-air`. Synced via its own remote
  (`git push`/`pull`), NOT a formal `git subtree` into a parent — the enclosing
  git repo is the home dir (dirty, doesn't track `projects/`) and
  `Apps/shinyobjectz` isn't its own repo, so embedding was declined. If a real
  monorepo boundary is wanted later, `git init Apps/shinyobjectz` then
  `git subtree add --prefix projects/out-of-thin-air <url> main --squash`.
  Model weights (`cli/sessions/_models/`, `*.pth/*.safetensors/*.onnx`) are
  gitignored — never commit them.

## CLI verb map (flat)

`oota serve` (was oota serve) · `oota new <title>` · `oota scaffold <cat> <tool> <title>` ·
`oota run <slug>` · `oota open <slug>` · `oota render <slug>` · `oota route <req>` ·
`oota hardware` · `oota models …` · `oota eval …` · `oota admin`.

Root monorepo Justfile drops the `code-as-*` verbs (they belong to the subtree's
own CLI now — enforces the separate-server / separate-product boundary).
