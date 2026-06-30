# music

Algorithmic composition / live coding — synthesis. Author code (Ruby, JS/TS, Haskell, sclang, or score DSL) and render it to an audio (or MIDI) artifact.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [sonic-pi](./sonic-pi.md) | audio (real-time WAV) | Rust, Python, Ruby, raw OSC, JS/Go | [Sonic Pi tutorial](https://sonic-pi.net/tutorial.html) | yes | ok | yes | yes (pre-existing, untouched) |
| [tone-js](./tone-js.md) | audio (offline WAV) | JS/TS (browser), JS/TS (Node headless), React | [Tone.js docs](https://tonejs.github.io/docs/) | yes | ok | yes (pre-existing) | yes (pre-existing) |
| [tidal-cycles](./tidal-cycles.md) | audio (SC-rendered WAV) | Haskell (canonical), JS/TS (Strudel), Python (vortex), Rust | [Tidal Cycles docs](https://tidalcycles.org/) | yes | ok | yes | yes |
| [supercollider](./supercollider.md) | audio (NRT AIFF/WAV/FLAC) | sclang (native), Python (supriya/sc3/osc), Haskell, Ruby, Clojure | [SuperCollider NRT docs](https://doc.sccode.org/Guides/Non-Realtime-Synthesis.html) | yes | ok | yes | yes |
| [alda](./alda.md) | audio (MIDI) | native CLI (Go+JVM), Ruby, Clojure, Python | [Alda docs](https://alda.io/docs/) | yes | ok | yes | yes |

## Multi-toolchain notes

- **Native required**: tidal-cycles (Haskell engine + SuperCollider/SuperDirt), supercollider (sclang), sonic-pi (server boot), alda (Go client + Kotlin/JVM player, needs Java).
- **JS/TS**: tone-js (browser + Node-headless via OfflineAudioContext shim, React), tidal-cycles via Strudel (`@strudel/core`, Web Audio, no SC needed).
- **Python**: sonic-pi (python-sonic / sonic-pi-tool.py / python-osc), supercollider (supriya / sc3 / python-osc), tidal-cycles (vortex, experimental), alda (community alda-python).
- **Ruby**: sonic-pi (gem), supercollider, alda (alda-rb).
- **Go**: sonic-pi (any OSC lib).
- **Clojure**: supercollider (overtone), alda (alda-clj).
- **React**: tone-js only.

## VALIDATION ORDER

Cheapest/most reliable first; heavy native+audio-device deps last.

1. **tone-js** — pure npm, headless OfflineAudioContext shim, deterministic WAV. No audio device, no GUI.
2. **alda** — `brew install alda` + Java; `alda export` is headless MIDI (no audio sink). Tiny, fast.
3. **supercollider** — `brew install --cask supercollider`; sclang NRT render needs no audio device (offline scsynth). Native but headless-friendly.
4. **sonic-pi** — `brew install --cask sonic-pi` + cargo tool; real-time capture, needs an audio sink (BlackHole) on headless macOS.
5. **tidal-cycles** — heaviest: Haskell (cabal install tidal) + SuperCollider + SuperDirt quark, two-process runtime, needs a working/virtual audio device. Strudel JS path is a lighter fallback.

## EXPLORER NEEDS

All five emit audio (or MIDI), so the default artifact shell wants an **inline audio player with waveform/scrubber** rather than a static download link. Beyond that:

- **sonic-pi / tidal-cycles**: live-coding tools — a richer explorer would offer a code REPL panel + live eval, not just one-shot render.
- **tidal-cycles**: pattern/cycle visualizer (Strudel-style) for the cyclic structure.
- **alda**: MIDI artifact — a piano-roll/notation viewer plus a soundfont-backed player (export is silent MIDI, not audio).
- **supercollider / tone-js**: one-shot offline render — default audio player suffices.
