---
name: capsule-exec
description: >-
  Run commands inside a project's devcontainer with `capsule exec`, so tests,
  builds and experiments happen in the container instead of on the host. Use
  when the user says to try, test, build or reproduce something "in the
  container", "in the devcontainer" or "with capsule", when a toolchain or
  dependency is missing on the host but a capsule template or
  `.devcontainer/` provides it, or when you want a clean, disposable Linux
  environment to verify a change.
---
# capsule exec

`capsule exec` starts (or reuses) the devcontainer for the current directory, runs one command in it, and returns that command's output and exit code. It is the non-interactive way in: use it for every command you want to run inside the container.

## Pick the target

Run from the project root. The container is keyed by the host directory, so the same directory always reaches the same container, and a different directory creates a new one.

- `.devcontainer/devcontainer.json` exists in the current directory: give no template name. Every positional argument is the command, even a word that matches a template name.
- No local `.devcontainer/`: the first positional argument is a stored template name. Run `capsule list` to see the names, and pick the one whose toolchain fits the project (or ask the user when several fit).

## Command form

Always write it like this:

```sh
capsule exec -q -- <cmd> [args...]              # local .devcontainer/
capsule exec -q <template> -- <cmd> [args...]   # stored template
```

- `-q` hides the `devcontainer up` log, so stdout is the command's own output. If startup fails, capsule prints the captured log anyway.
- `--` is required. Capsule parses its own flags (`-q`, `--quiet`, `--rebuild`, `--recreate`) anywhere on the line, so without `--` the command `pytest -q` silently loses its `-q`, and `make --rebuild` destroys the container.
- The command runs directly, without a shell. For pipes, `&&`, redirects, globs or `$VAR`, wrap it: `capsule exec -q -- sh -c 'cd sub && make 2>&1 | tail -50'`.

## How the container behaves

- **Workspace is live.** The host directory is mounted at `/workspaces/<dirname>`, and each command starts there. Edit files on the host with your normal tools; the container sees the change immediately. No copy step.
- **Each call is a fresh process.** `cd`, `export` and shell state do not carry over between calls. Chain dependent steps in one `sh -c`.
- **Container state persists.** Packages installed with `apt`, `pip` or `npm -g`, and files outside the workspace, survive between calls until the container is recreated. Install a missing tool once, then reuse it.
- **Host env is not forwarded.** Only variables from `~/.config/capsule/config.toml` `[env]`, the devcontainer's `remoteEnv`, `UID` and `GID` reach the container. Pass anything else inline: `-- env FOO=1 make`.
- **The exit code is the command's.** Read success or failure from it directly.
- **The user is the image's user** (`vscode` on Microsoft images), not root. Use `sudo` when the image provides it.

## Timing

The first call for a directory pulls the image and runs `postCreateCommand`: allow several minutes (use a 10-minute timeout, or run it in the background). Later calls take a few seconds. To warm the container before real work: `capsule exec -q [template] -- true`.

## Recreating

`--recreate` destroys the container and creates a new one from the current `devcontainer.json`. `--rebuild` does the same and also rebuilds a Dockerfile-based image without the build cache. Use either only when `devcontainer.json` or the capsule mounts changed, the image is stale, or the container is broken. Both wipe all installed state, so tell the user before you use them. Put it before `--`: `capsule exec -q --recreate -- true`.

## Stay non-interactive

Commands that wait for input hang the call. Run one-shot forms instead: `python -c` or a script instead of a REPL, `pytest` instead of `pytest --pdb`, `git --no-pager log`. `capsule run` opens an interactive shell, so leave it for the user.

## Cleanup

Leave the container running between calls; reuse is the point. When the user wants it gone, run `capsule stop` (stop) or `capsule stop --force` (remove) from the same directory. `capsule ps` lists every capsule container.

## Failures

- `devcontainer CLI not found`: the user must install it (`npm install -g @devcontainers/cli`).
- `No .devcontainer/devcontainer.json found and no template name given`: pass a template name, or set the project up with the `capsule` skill.
- `devcontainer up failed`: read the printed log. Common causes are a bad `devcontainer.json`, a failing `postCreateCommand`, or a stopped container runtime. `capsule doctor` checks the runtime and every template.
