<!-- generated draft — needs validation -->
# tone-js

## Summary
Tone.js is a Web Audio framework for interactive music in the browser: a global Transport for scheduling, prebuilt synths/effects, and audio-rate signal building blocks. Code-as-music means you write JS/TS to construct synths/sequences and either play live in a browser tab or render offline to an `AudioBuffer` via `Tone.Offline` / `OfflineContext`, which is exported to WAV. The primary durable deliverable is **audio** (a `.wav` from offline render); the live experience is HTML+JS in a browser. No dedicated Anthropic/Claude SKILL.md exists; the toolchain is JS/TS only (browser, or Node with a Web Audio shim).

## Skills
| Skill | URL | Official/Community | License | Attribution |
|-------|-----|--------------------|---------|-------------|
| Tone.js official docs | https://tonejs.github.io/docs/ | official | MIT | Tonejs org |
| Tonejs/Tone.js (source + examples + wiki) | https://github.com/Tonejs/Tone.js | official | MIT | Yotam Mann / Tonejs contributors |
| Tone.js examples gallery | https://tonejs.github.io/examples/ | official | MIT | Tonejs org |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JS/TS (browser) | `npm install tone` | `import * as Tone from 'tone'`; build synths, call `Tone.start()` on a user gesture, schedule on `Tone.Transport`; live playback in a browser tab |
| JS/TS (Node, headless) | `npm install tone node-web-audio-api audiobuffer-to-wav` | Node has no native AudioContext. Set Web Audio globals from `node-web-audio-api`, use `Tone.Offline(cb, duration)` to render an `AudioBuffer` faster-than-realtime, then `audiobuffer-to-wav` + `fs.writeFile` for a `.wav` |
| React | `npm install tone` | Use Tone inside `useEffect`/refs; common for live-coding and visualizer UIs. Same package, no React wrapper required |

## Artifact kind
**audio** — the offline-rendered `.wav` is the durable deliverable. Live/interactive mode is HTML+JS but ephemeral.

## Validation
- **Install:** `npm install tone node-web-audio-api audiobuffer-to-wav`
- **Smoke:**
  ```bash
  node -e "globalThis.AudioContext=require('node-web-audio-api').AudioContext; globalThis.OfflineAudioContext=require('node-web-audio-api').OfflineAudioContext; const Tone=require('tone'); const toWav=require('audiobuffer-to-wav'); const fs=require('fs'); Tone.Offline(()=>{const s=new Tone.Synth().toDestination(); s.triggerAttackRelease('C4','8n',0.1);},1).then(buf=>{fs.writeFileSync('out.wav',Buffer.from(toWav(buf.get()))); console.log('wrote out.wav');});"
  ```
- **Expect:** Writes `out.wav` (~1s, 44.1kHz PCM) containing a single C4 note. The Node shim provides `OfflineAudioContext` so render works headless on macOS. NOTE: verify shim API names against the current `node-web-audio-api` version; if `Tone.Offline` needs the globals set before `require('tone')`, set globals first (as shown).

## Wrapper params
- **render duration** (seconds) and **sample rate** for `Tone.Offline`
- **BPM** — `Tone.Transport.bpm`
- **master volume** — `Tone.Destination`
- **instrument choice** — Synth / FMSynth / PolySynth / Sampler
- **note sequence / pattern** — `Tone.Sequence` / `Tone.Part`
- **effect chain** — reverb / delay / filter
- **live mode** — start/stop transport toggle

## Component / explorer notes
The default audio artifact shell (a wav/audio player) renders the offline output fine. The live/interactive side (real-time synth params, sequencer, visualizers) wants a richer HTML explorer with a "start audio" gesture button and parameter controls, since browsers require a user interaction to unlock the AudioContext.
