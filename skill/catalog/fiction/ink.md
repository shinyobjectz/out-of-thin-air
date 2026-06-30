<!-- generated draft — needs validation -->
# ink (fiction)

## Summary
ink is inkle's open-source markup scripting language for branching interactive
narrative. Authors write `.ink` (prose + choices + logic + variables/state); the
`inklecate` compiler turns it into a `.json` story file; a runtime (inkjs,
bladeink, inkcpp, Unity plugin, etc.) plays that JSON, tracking stateful
variables, choices, and flow. The primary deliverable is an interactive,
playable story — best surfaced as an HTML web player (inkjs) that renders
narrative text, presents clickable choices, and persists variable/flow state
across turns. The compiled artifact is JSON; raw authoring output is text.

## Skills
| Skill | URL | Type | License | Attribution |
|-------|-----|------|---------|-------------|
| Writing With Ink (full language guide) | https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md | official-docs | MIT | inkle Ltd / inkle/ink |
| ink homepage + web tutorial | https://www.inklestudios.com/ink/web-tutorial/ | official-docs | docs | inkle Studios |
| inkle/ink-library — curated samples, tools, ports list | https://github.com/inkle/ink-library | repo (official) | MIT | inkle Ltd |
| DeepWiki: Web and JavaScript (inkjs) usage guide | https://deepwiki.com/inkle/ink-library/3.2-web-and-javascript | community | n/a | DeepWiki |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Native CLI (.NET) | Download `inklecate` release from https://github.com/inkle/ink/releases and unzip (macOS: copy to /usr/local/bin) | `./inklecate myStory.ink` → `myStory.json`; play: `./inklecate -p myStory.ink`; output path: `./inklecate -o out.json myStory.ink` |
| JS/TS / React / Node / browser | `npm i inkjs` (compiler wrapper: `npm i -D inklecate`) | Compile in-process + run via `new Story(json)`; `story.Continue()` / `story.currentChoices` / `story.ChooseChoiceIndex(i)`. Powers HTML web players. |
| Rust | `cargo add bladeink` | Plays compiled JSON (does NOT compile .ink). `Story::new(json)`; `cont_maximally()`; `choose_choice_index(i)` |
| Python | `pip install inkcpp-py` | Bindings to inkcpp C++ runtime. Loads compiled `.json`/`.bin`; `inkcpp_py.Story` / runner to step lines and choices. Pre-compile with inklecate. |
| C++ / C | clone https://github.com/JBenda/inkcpp + build with CMake (ships `inkcpp_cl` + inklecate) | Compact embeddable runtime; `inkcpp_cl` plays/compiles |
| C# / Unity | Unity Asset Store / OpenUPM: `ink-unity-integration`; or ref `ink-engine-runtime.dll` | Auto-compiles `.ink` in-editor; Story C# API at runtime |
| Java | Maven/Gradle: `com.bladecoder.ink:blade-ink` | JVM port; plays compiled JSON |

## Artifact kind
`html` — an inkjs-powered interactive web player. (Compiled intermediate is JSON;
terminal play via `./inklecate -p` is the pure-native alternative.)

## Validation
- **install**: `npm i inkjs inklecate`
- **smoke**:
  ```bash
  printf 'Hello from ink.\n* [Wave] You wave.\n* [Nod] You nod.\n- -> END\n' > story.ink \
    && npx inklecate -o story.json story.ink \
    && node -e "const{Story}=require('inkjs');const s=new Story(require('fs').readFileSync('story.json','utf8'));let out='';while(s.canContinue)out+=s.Continue();s.currentChoices.forEach((c,i)=>out+='['+i+'] '+c.text+'\n');require('fs').writeFileSync('out.txt',out);console.log(out)"
  ```
- **expect**: Compiles `story.ink` → `story.json`, then runs the runtime headlessly
  producing `out.txt` containing `Hello from ink.` followed by `[0] Wave` /
  `[1] Nod`. Confirms both compiler and runtime work.

## Wrapper params
- Source mode: input `.ink` source vs pre-compiled `.json`
- inklecate flags: `-o` (output path), `-p` (play mode), `-c` (count visits),
  `-j` (JSON status output for tooling)
- Runtime hooks: choice-selection callback (`ChooseChoiceIndex`), variable
  get/set (`story.variablesState`), save/load (`story.state.toJson` /
  `loadJson`), tags + external functions
- Web wrapper extras: seed/auto-advance option, transcript export

## Component / explorer notes
The deliverable is a stateful, playable story, not a static file. The default
text/JSON artifact shell can show the compiled `.json` or a terminal transcript,
but the natural deliverable is a richer HTML explorer: an inkjs web player that
renders narrative text, presents clickable choices, and persists variable/flow
state across turns. A plain static shell undersells it — choices need
interactivity.
