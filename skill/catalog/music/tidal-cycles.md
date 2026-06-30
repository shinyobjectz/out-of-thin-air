# tidal-cycles

## Summary
TidalCycles ("Tidal") is a free/open-source live-coding environment for algorithmic
patterns, written in Haskell. Tidal itself only *generates* patterns and emits them as
OSC messages; the actual sound is synthesized by **SuperDirt**, a Quark running inside
**SuperCollider**. The runtime is therefore always two-process: a Tidal pattern engine
(Haskell/GHCi, or a port) + SuperCollider/SuperDirt as the audio backend. The primary
deliverable is **audio**. No official Anthropic/Claude SKILL.md or curated llms.txt
exists for tidal-cycles; the canonical knowledge base is the official docs plus the
community userbase wiki. Notable ports: **Strudel** (faithful JS/TS port, runs
in-browser/Node on Web Audio — no SuperCollider needed) and **Vortex** (experimental
Python port). A Rust helper crate (`tidalcycles-rs`) boots SuperCollider+SuperDirt+GHCi
headlessly for automation.

Confidence: medium. Install/toolchain facts are well-sourced, but a fully-headless macOS
smoke-to-file path depends on SuperCollider audio device / recording config that varies
per machine (may require a virtual device like BlackHole).

## Skills (attributed references)
| Name | Type | URL | Official | License | Attribution |
| --- | --- | --- | --- | --- | --- |
| Official Tidal Cycles documentation | official-docs | https://tidalcycles.org/docs/ | yes | docs (CC-style, see site) | TidalCycles project / Alex McLean |
| TidalCycles userbase wiki | community | https://userbase.tidalcycles.org/ | no | community wiki | Tidal community |
| Strudel docs (JS port; learn/workshop pages) | official-docs | https://strudel.cc/ | yes | AGPL-3.0 (strudel repo) | uzu/strudel (Codeberg) |
| No dedicated Anthropic/Claude SKILL.md or llms.txt found | community | https://github.com/anthropics/skills | no | n/a | searched anthropics/skills + awesome-agent-skills; none as of 2026-06 |

## Toolchains
| lang | install | invoke |
| --- | --- | --- |
| Haskell (native, canonical) | `cabal update && cabal install tidal`; in SuperCollider run `Quarks.install("SuperDirt")` | drive GHCi REPL (BootTidal.hs) → emits OSC to SuperDirt; no standalone CLI binary |
| JS/TS / React / Node (Strudel) | `npm install @strudel/core @strudel/web` (or use https://strudel.cc) | run in browser/Node Web Audio; offline render |
| Python (Vortex) | `git clone https://codeberg.org/uzu/vortex && cd vortex && pip install -e .` | sends OSC to SuperDirt like Haskell Tidal (experimental) |
| Rust (headless harness) | `cargo install tidalcycles-rs` (needs SuperCollider, SuperDirt, GHC/Tidal) | boots SuperCollider+SuperDirt+GHCi headlessly for automated workflows |

## Artifact kind
**audio** — a rendered WAV/multichannel file from SuperCollider's `s.record`, or a
rendered Web Audio buffer from Strudel. The universal audio shell plays a rendered `.wav`.

## Validation
### install (macOS / Homebrew)
```bash
brew install --cask supercollider
brew install ghc cabal-install
cabal update && cabal install tidal
# In SuperCollider GUI run once: Quarks.install("SuperDirt"); thisProcess.recompile()
# Easiest cross-check without SuperCollider — the JS port:
npm install @strudel/core
```
### smoke (headless audio render via SuperCollider recording)
```bash
sclang -i tidal <<'SC'
(SuperDirt.start; s.waitForBoot { s.record("/tmp/tidal_smoke.wav"); });
SC
# In a GHCi Tidal session send a pattern, e.g.:  d1 $ sound "bd sn hh sn"
# stop:  s.stopRecording  -> /tmp/tidal_smoke.wav
# NOTE: needs a working audio device; on pure-CI macOS use a virtual device (BlackHole).
```
### expect
A non-empty `/tmp/tidal_smoke.wav` (PCM WAV) containing the four-step drum pattern;
`ffprobe /tmp/tidal_smoke.wav` should report a valid duration > 0s. Silent/zero-length =>
SuperDirt didn't boot or there's no sample/audio device — check sclang output.

## Wrapper params
- `music.title` — label
- pattern/code string itself (`d1..dN` mini-notation)
- `cps` / tempo (cycles per second)
- cycle count or render duration
- sample bank / SuperDirt soundfont path
- output WAV path + channel count
- backend selection (SuperDirt OSC host:port vs Strudel Web Audio)
- (headless) SuperCollider boot script + audio device
- (Strudel) sample-map URL + offline-render length

## Component / explorer notes
Primary artifact is an audio file (WAV/multichannel from `s.record`, or rendered Web
Audio in Strudel). The default audio shell plays a rendered `.wav` directly. A richer
explorer adds value: live-coding's real product is the time-varying pattern + code, so a
panel pairing the editable pattern source with a waveform/transport and a re-render button
beats a static audio tag. Strudel's web REPL is the reference rich-explorer experience.
