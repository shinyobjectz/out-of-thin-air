<!-- generated-draft -->
# generative-text

Procedural text from grammars — bots, dialogue, expandable templates.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|-----------|---------------|-----------|--------|----------|-------|
| [tracery](./tracery.md) | text | Python, JS/TS, JVM | [galaxykate/tracery](https://github.com/galaxykate/tracery) | yes | ok | yes | yes |

## MULTI-TOOLCHAIN NOTES

- **tracery** — Py (`pip install tracery` → `python -m tracery`), JS/TS (`npm install tracery-grammar` → `createGrammar`/`flatten`; or vendor `tracery.js` from galaxykate), JVM (AlmasB/grammy via Maven/Gradle). No Go or native React build; React consumes the JS grammar package directly.

## VALIDATION ORDER

1. **tracery** — `pip install tracery` is a tiny pure-Python install; smoke test writes a minimal `grammar.json`, flattens `#origin#` into 5 lines, and runs fully headless on macOS. Cheapest and most reliable; validate first.

## EXPLORER NEEDS

None. All tools in this category emit flattened plain text that renders in the universal/default text shell. No richer explorer (canvas, 3D orbit, audio) required.

## DOSSIERS

- [tracery](./tracery.md)
