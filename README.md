# Dotfiles

My personal configuration for Ubuntu (native or WSL2), managed as a bare git
repository in `~/.cfg` and installed with a small helper, `dot`.

## Requirements

- Ubuntu 24.04 (the installer uses `apt`)
- `curl` and `sudo`

## Installation

The installer clones this repository as a bare repo into `~/.cfg`, checks it
out into `$HOME` (overwriting existing files), links `dot` into
`~/.local/bin`, and installs the programs for the chosen profile.

Set `GIT_CLONE_METHOD=ssh` if your SSH key is on GitHub, or `https`
otherwise.

### Complete

```sh
export GIT_CLONE_METHOD=ssh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/dot-manager/first_install.sh)"
```

### Minimal

A lighter set of programs (nvim, fzf, fd, eza, zoxide, starship, git tools,
Copilot CLI).

```sh
export DOTFILES_MINIMAL=1
export GIT_CLONE_METHOD=ssh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/dot-manager/first_install.sh)"
```

### Docker

For use inside a container (nvim, fzf, fd, eza, bat, zoxide, starship, git
tools).

```sh
export DOTFILES_DOCKER=1
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/dot-manager/first_install.sh)"
```

The minimal and docker profiles are remembered in `~/.profile`, so later
`dot reinstall all` keeps the same profile.

## Usage

```
dot <command> [args]

  list                     List installable programs
  init                     Install the complete configuration
  minimal                  Install the minimal configuration
  docker                   Install the docker configuration
  update                   Update nvim, tmux and antidote plugins
  reinstall <name|all>     Reinstall a program (or everything); fzf picker without a name
  terminal install <name>  Install a terminal (wezterm, kitty, ghostty)
  fonts update             Install Nerd Fonts
  tool <name>              Run a tool script (e.g. dotnet)
  help                     Show this help
```

Any other command is passed to git on the dotfiles repository:

```sh
dot status
dot add ~/.config/nvim/init.lua
dot commit -m "feat(nvim): ..."
dot push
```

## Agent skills

The complete profile installs my
[casquette](https://github.com/rachartier/casquette) skills: it clones the
repo into `~/dev/casquette` and links `~/.agents/skills/my-skills` to its
`skills/` folder, so edits in the clone apply right away. Private skills stay
in this repo, in `~/.agents/skills/private`.

Clone or update casquette on its own:

```sh
dot reinstall casquette
```

## Testing in Docker

Start a container:

```sh
docker run --privileged -ti ubuntu:24.04 /bin/bash
```

Inside it, create a user whose password is `test`:

```sh
apt update && apt install -y curl sudo && useradd -m -p "$(perl -e 'print crypt($ARGV[0], "password")' 'test')" dotfilesuser && usermod -aG sudo dotfilesuser && su dotfilesuser
```

Install the dotfiles, typing `test` when the password is asked:

```sh
export DOTFILES_DOCKER=1
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/dot-manager/first_install.sh)"
```

When it finishes, start `zsh` and try the config.

## Dev container

A portable environment with the dotfiles preinstalled, to use on any machine
with Docker. `~/dev` is mounted into the container.

With the script (installs Docker if needed, then starts or attaches to the
container):

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/setup-container-env.sh)"
```

Or directly with Docker:

```sh
docker run -d -ti --privileged --net=host \
    -v "$HOME/dev:/home/ubuntu/dev" \
    -v "$HOME/.config/github-copilot:/home/ubuntu/.config/github-copilot" \
    -v "/tmp/X11-unix:/tmp/X11-unix" \
    -e DISPLAY="$DISPLAY" \
    --name dotfile-dev --entrypoint zsh \
    rachartier/dotfile-dev:latest
docker exec -it dotfile-dev zsh
```

To build the image yourself:

```sh
cd ~/.config/dot-manager
docker build --build-arg USER_NAME=ubuntu -t rachartier/dotfile-dev:latest .
```
