#!/usr/bin/env bun
/**
 * oota — Out Of Thin Air CLI.
 * Flat verbs that wrap the polyglot step scripts + the standalone nexus serve.
 * The project root is the subtree dir (parent of this package).
 */
import { spawnSync } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url)); // <subtree>/oota/bin
const PROJECT = resolve(HERE, "..", ".."); // <subtree>
const TOOLS = join(PROJECT, "tools");
const CLI = join(PROJECT, "cli");
const PORT = process.env.PORT || "4010";
const NEXUS = process.env.OOTA_NEXUS || resolve(PROJECT, "..", "..", "..", "workbooks", "nexus");

function sh(cmd: string, args: string[], env: Record<string, string> = {}, cwd = PROJECT): number {
  const r = spawnSync(cmd, args, { stdio: "inherit", env: { ...process.env, ...env }, cwd });
  return r.status ?? 1;
}
function bash(script: string, args: string[], env: Record<string, string> = {}): number {
  return sh("bash", [join(TOOLS, script), ...args], env);
}
function slugify(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
}

function newSession(title: string, cat = "diagrams", tool = "mermaid"): number {
  const slug = slugify(title);
  const dir = join(CLI, "sessions", slug);
  if (existsSync(dir)) { console.error(`exists: ${dir}`); return 1; }
  mkdirSync(join(dir, "out"), { recursive: true });
  const body = `# ${title}\n\ncard do\n  board: "code-as"\n  status: "draft"\n  slug: "${slug}"\nend\n\n## Requirements\n\n_Describe what you are making._\n\nchain do\n  ${cat}: ${tool}\nend\n\nparams do\n  ${cat}.title: "${title}"\nend\n`;
  writeFileSync(join(dir, "session.work"), body);
  console.log(`created ${join(dir, "session.work")} (${cat}: ${tool})`);
  console.log(`run:  oota run ${slug}`);
  console.log(`open: oota open ${slug}   (after oota serve)`);
  return 0;
}

const HELP = `oota — Out Of Thin Air

Usage: oota <command> [args]

  serve                         serve this project on its own nexus (:${PORT})
  new <title>                   scaffold a session (default diagrams/mermaid)
  scaffold <category> <tool> <title>   scaffold a session wired to one chain
  run <slug>                    run a session's tool chain → out/
  render <slug>                 render the final artifact (e.g. video)
  open <slug>                   print the artifact-shell URL
  route "<requirements>"        print a route proposal (needs serve running)
  hardware                      probe RAM/GPU for local models
  models [args]                 list/check/download local models
  eval [args]                   blind agent eval scenarios
  admin                         print the session admin CLI URL
  help                          this message

Env: PORT (default ${PORT}), OOTA_NEXUS (nexus runtime path).`;

const [cmd, ...rest] = process.argv.slice(2);

switch (cmd) {
  case "serve":
    process.exit(sh(
      "elixir", ["--no-halt", "-S", "mix", "run"],
      { WB_SERVE: "1", PORT, OOTA_BASE: "", WB_DATA: PROJECT },
      NEXUS,
    ));
    break;
  case "new":
    if (!rest[0]) { console.error("usage: oota new <title>"); process.exit(1); }
    process.exit(newSession(rest.join(" ")));
    break;
  case "scaffold":
    if (rest.length < 2) { console.error("usage: oota scaffold <category> <tool> <title>"); process.exit(1); }
    process.exit(bash("scaffold.sh", [rest[0], rest[1], rest.slice(2).join(" ")]));
    break;
  case "run":
    process.exit(bash("run.sh", [rest[0] ?? ""]));
    break;
  case "render":
    process.exit(bash("render.sh", [rest[0] ?? ""]));
    break;
  case "open":
    if (!rest[0]) { console.error("usage: oota open <slug>"); process.exit(1); }
    console.log(`http://localhost:${PORT}/components/artifact?slug=${rest[0]}`);
    break;
  case "route":
    process.exit(bash("route.sh", rest, { PORT }));
    break;
  case "hardware":
    process.exit(bash("hardware.sh", []));
    break;
  case "models":
    process.exit(bash("models.sh", rest));
    break;
  case "eval":
    process.exit(bash("eval.sh", rest));
    break;
  case "admin":
    console.log(`http://localhost:${PORT}/cli   (run \`oota serve\` first)`);
    break;
  case "help": case "--help": case "-h": case undefined:
    console.log(HELP);
    break;
  default:
    console.error(`unknown command: ${cmd}\n`);
    console.log(HELP);
    process.exit(1);
}
