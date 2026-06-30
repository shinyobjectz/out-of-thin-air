# oota — Out Of Thin Air

Author any deliverable — decks, video, audio, diagrams, docs, 3D, games, … — as
**deterministic, version-controllable code**, render it headlessly, and view it
in a universal browser shell. "Code-as-X" is the first capability under the OOTA
umbrella.

## Install

```bash
bun add -g oota      # or: npx oota <command>
```

## Use

```bash
oota serve                              # serve on its own nexus (:4010)
oota scaffold diagrams d2 "My diagram"  # wire a session to one chain
oota run my-diagram                     # run the chain → out/
oota open my-diagram                    # print the artifact-shell URL
oota help
```

Runs on [Bun](https://bun.sh). Set `OOTA_NEXUS` to the nexus runtime path and
`PORT` to change the port (default 4010).
