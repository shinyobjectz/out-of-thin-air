#!/usr/bin/env bash
# Portable CLI when only projects/out-of-thin-air/ is available.
set shell := ["bash", "-uc"]

root := justfile_directory()
tools := root / "tools"
cli := root / "cli"

# Standalone serve config. This subtree runs on its OWN nexus — never the studio's.
# Override NEXUS if the runtime lives elsewhere when vendored out.
PORT := env_var_or_default("PORT", "4010")
NEXUS := env_var_or_default("NEXUS", root / "../../../workbooks/nexus")

default:
    @just --list

# Serve this project standalone on its own nexus + port (OOTA_BASE="" → root mounts).
serve:
    #!/usr/bin/env bash
    set -euo pipefail
    [ -f "{{root}}/.env" ] && { set -a; . "{{root}}/.env"; set +a; }
    cd "{{NEXUS}}"
    WB_SERVE=1 PORT={{PORT}} OOTA_BASE="" WB_DATA="{{root}}" elixir --no-halt -S mix run

# Print the artifact-shell URL for a session (after `just serve`).
open slug:
    @echo "http://localhost:{{PORT}}/components/artifact?slug={{slug}}"

scaffold category tool title="":
    @bash {{tools}}/scaffold.sh "{{category}}" "{{tool}}" "{{title}}"

run slug:
    bash {{tools}}/run.sh "{{slug}}"

render slug:
    bash {{tools}}/render.sh "{{slug}}"

preview slug action="start":
    bash {{tools}}/preview.sh "{{slug}}" "{{action}}"

hardware:
    bash {{tools}}/hardware.sh

models *args:
    bash {{tools}}/models.sh {{args}}

tts-setup:
    bash {{tools}}/tts-setup.sh

eval *args:
    bash {{tools}}/eval.sh {{args}}

score scenario:
    bash {{tools}}/score.sh "{{scenario}}"

new title:
    #!/usr/bin/env bash
    set -euo pipefail
    slug=$(echo "{{title}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
    dir="{{cli}}/sessions/$slug"
    mkdir -p "$dir/out"
    sed "s/@@TITLE@@/{{title}}/g; s/@@SLUG@@/$slug/g; s/@@REQUIREMENTS@@/_Describe what you are making._/g" \
      "{{cli}}/_template/session.work" > "$dir/session.work"
    echo "created $dir/session.work"
