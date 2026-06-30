# Verbs

## Monorepo root

```bash
oota serve                 # serve code-as on its OWN nexus :4010 (not the studio)
oota new "Title"
oota run <slug>
oota render <slug>
oota hardware
oota models list [task]
oota eval list|reset|prompt|run|score <scenario>
oota validate
```

## Project-only (`projects/oota anything/Justfile`)

```bash
just run <slug>
just render <slug>
just hardware
just models list tts
just eval score hardware-smoke
just new "Title"
```

## Auto-route API

| Method | Path | Body |
|--------|------|------|
| POST | `/code-as/route` | `{ requirements, title? }` → `{ chain, params, rationale }` |
| POST | `/code-as/session/route` | `{ slug, requirements? }` → applies route to session |
| GET | `/code-as/hardware` | RAM, GPU, runtimes JSON |
| GET | `/code-as/models?task=tts` | Model list + hardware snapshot |

Worktop: **Suggest chain** in the session editor. Sidebar shows hardware when nexus is up.

New sessions with requirements in the create modal auto-route on scaffold.

## Worktop

http://localhost:4010/cli
