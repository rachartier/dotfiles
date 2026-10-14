---
name: capsule
description: >-
  Set up and manage devcontainers with the capsule CLI: store and edit
  devcontainer templates, add a `.devcontainer/` to a project with `capsule
  init`, write a new template, and configure `~/.config/capsule/config.toml`
  (bind mounts, env, shell, uid/gid). Use when the user mentions
  capsule, wants a devcontainer for a project, wants to add, fork, update or
  troubleshoot a template, or wants their dotfiles, SSH keys, display or env
  inside every container. For running commands inside a container, use
  `capsule-exec`.
---
# capsule

Capsule keeps devcontainer templates in one store and runs them in any project through the `devcontainer` CLI. Run `capsule --help` or `capsule <cmd> --help` for exact flags; this skill covers what the help text does not say.

## Where things live

- Template store: `~/.config/capsule/templates/<name>/` (or under `$XDG_CONFIG_HOME`). Each template is a directory with `devcontainer.json`, plus any files it references (`Dockerfile`, scripts), plus capsule's own `capsule.toml` (description, author, git provenance, uid/gid override).
- Global config: `~/.config/capsule/config.toml`. Optional; see [Global config](#global-config).
- Log: `~/.config/capsule/capsule.log`. Read it when a command fails without a clear message.

## Interactive commands

These commands wait for a human, so leave them to the user or use the non-interactive form:

| Interactive | Use instead |
| --- | --- |
| `capsule run` (opens a shell) | Tell the user to run it. Preview with `capsule run [template] --dry-run`. Start the container with `capsule exec -q [template] -- true`. |
| `capsule edit <t>` (opens `$EDITOR`) | Edit `~/.config/capsule/templates/<t>/devcontainer.json` directly. |
| `capsule delete <t>` (asks to confirm) | `capsule delete <t> --force`, after the user agrees. |
| `capsule run` with no template and no `.devcontainer/` (opens a picker) | Pass the template name. |

## First-time setup

1. `capsule doctor` checks the `devcontainer` CLI, docker or podman, every stored template, and `config.toml`. Fix what it reports first. A missing `devcontainer` CLI is installed with `npm install -g @devcontainers/cli`.
2. `capsule list`. If the store is empty, add the shipped templates (c, cpp, node, python, python-qt, rust): `capsule add gh:rachartier/capsule/templates`.
3. `capsule config init` writes a commented default `config.toml`. It refuses to overwrite an existing file unless `--force` is given; read the existing file before you overwrite it.

## Templates

**Add.** `capsule add <source>` accepts a local directory, `gh:owner/repo[@ref][/subpath]`, a GitHub tree URL, or any git URL (with `--ref` and `--subpath`). A source with `devcontainer.json` at its top becomes one template, named after the directory unless `--name` is given. A source without one is scanned for child directories that contain `devcontainer.json`, and each becomes a template; existing names are skipped. Git sources record provenance, so `capsule pull <t>` re-fetches later.

**Write a new one.** Create a directory with a `devcontainer.json` (and a `Dockerfile` if needed), then `capsule add ./that-dir --name <t>`. Follow the shipped templates: start from an `mcr.microsoft.com/devcontainers/*` image, add `features`, install project dependencies in `postCreateCommand` so the same template works for many projects. Capsule-specific keys:

- `customizations.capsule.shell`: shell that `capsule run` opens for this template (for example `/bin/zsh`).
- Capsule passes `UID` and `GID` as remote env vars. Nothing consumes them unless the template's `postCreateCommand` does.

Set a description so `capsule list` explains the template: `capsule meta <t> --description "..."`.

**Prove it works.** A template is done when every tool the user asked for runs in a real container: `capsule exec -q <t> -- sh -c 'go version && gopls version'` from a scratch directory. Base images often lack the tools you expect (`devcontainers/go` ships no `gopls`), so install what is missing in `postCreateCommand`, pinned to a version that supports the image's toolchain. Remove the scratch container afterwards with `capsule stop --force`.

**Change one.** Edit the stored `devcontainer.json` directly. `capsule update <dir> --name <t>` and `capsule pull <t>` replace every template file except `capsule.toml`, so local edits to the template are lost. Other commands: `view`, `search <keyword>`, `rename`, `export`.

## Project devcontainer

- `capsule run <t>` or `capsule exec <t> -- ...` uses the stored template directly, with no copy in the project. Prefer this when the project needs nothing special.
- `capsule init <t>` copies the template into `./.devcontainer/` (`--output` for another path, `--force` to overwrite). Use it when the project needs its own tweaks; edit the copy, not the store. After that, `capsule run` and `capsule exec` with no template name use the local copy.

Precedence: `capsule run <t>` with a name uses the stored template even when `.devcontainer/` exists. `capsule exec` always uses `.devcontainer/` when it exists and treats every argument as the command.

**Apply changes.** An existing container keeps its old settings. After a change to `devcontainer.json` or to the mounts in `config.toml`, the container must be recreated: `capsule run --recreate` (the user) or `capsule exec -q --recreate [t] -- true` (you). Recreating destroys everything installed in the container, so confirm with the user first. For a Dockerfile template whose cached layers are stale (an old `apt-get update`, a moved `git clone`), use `--rebuild` instead: it also rebuilds the image without the build cache.

## Global config

`config.toml` applies to every container. `~` and `$VAR` in mount host paths and `[env]` values expand from the host shell at run time. Show the resolved values with `capsule config`.

```toml
[volumes]    # bind mounts for dotfiles and data; "host_path:container_path"
mounts = ["~/.gitconfig:/home/vscode/.gitconfig", "/data:/data"]

[env]        # injected into every container
TERM = "xterm-256color"
DISPLAY = "$DISPLAY"

[run]
shell = "/bin/zsh"   # overrides customizations.capsule.shell for all templates
quiet = false        # true hides devcontainer up output behind a spinner
# uid = 1000         # default: host uid
# gid = 1000         # default: host gid
```

- **Mounts from `config.toml` are always writable.** Capsule rejects a third field such as `:ro`, because `devcontainer up --mount` cannot take it. For a read-only mount (SSH keys), put it in the template's `devcontainer.json` instead: `"mounts": ["source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,readonly"]`.
- **Container path must match the container user's home, and it differs per image**: most Microsoft images use `vscode`, `javascript-node` uses `node`, others use `root`. One global dotfile mount fits only templates that share a user. Check with `capsule exec -q <t> -- sh -c 'echo $HOME'`.
- A mount whose host or container path is already declared in the template's `mounts` is skipped, so the template wins.
- `[dotfiles]` is deprecated: its mounts still apply, with a warning. Move them to `[volumes]` when you edit the config.
- uid/gid precedence: per-template override (`capsule meta <t> --uid N --gid N`, `-1` to unset) over `[run]` over the host's ids.

For GUI apps on WSL2, mount `/tmp/.X11-unix:/tmp/.X11-unix` in `[volumes]`. With WSLg, set `DISPLAY = ":0"`, `WAYLAND_DISPLAY = "wayland-0"` and `XDG_RUNTIME_DIR = "/mnt/wslg/runtime-dir"` in `[env]`; with an external X server (VcXsrv, X410), set `DISPLAY = "$DISPLAY"`.
