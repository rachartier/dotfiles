# Dotfiles

Full installation
--------------------

```
export GIT_CLONE_METHOD=ssh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

Minimal installation
--------------------

```
export DOTFILES_MINIMAL=1
export GIT_CLONE_METHOD=ssh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

Docker installation
--------------------

```
export DOTFILES_DOCKER=1
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

## Testing inside a docker:

Launch a docker container: 
```
docker run --privileged  -ti ubuntu:22.04 /bin/bash
```

When inside, create a user (password is set to "test"):
```
apt update && apt install -y curl sudo && yes | useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' 'test') dotfilesuser && usermod -aG sudo dotfilesuser && su dotfilesuser
```

Next, install the dotfiles, and when the password is asked, type "test":
```
export DOTFILES_DOCKER=1 
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

Finally, when all is finished, type:

```
zsh
```

and next:
```
cd && export LANG=en_US.UTF-8 && export APPIMAGE_EXTRACT_AND_RUN=1
```

You should be able to try the config!

# [WIP] Dotfiles DEV

A portable dotfiles, in a docker, to be used on any device without installation.

## With a script

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/setup-container-env.sh)"
```

## Directly with docker
```
docker run -v "$HOME/dev:/home/ubuntu/dev" -v "$HOME/.config/github-copilot:/home/ubuntu/.config/github-copilot" -v "/tmp/X11-unix:/tmp/X11-unix" -e DISPLAY=$DISPLAY --net=host --name="dotfile-dev" --entrypoint zsh --privileged -d -ti rachartier/dotfile-dev:latest
```

# Images
![image](https://github.com/rachartier/dotfiles/assets/2057541/d70e00d6-8186-461e-af5b-94ea32e0a345)

![image](https://github.com/rachartier/dotfiles/assets/2057541/729ad6ea-7b5a-4227-8dbd-cbe11b13e908)

![image](https://github.com/rachartier/dotfiles/assets/2057541/2627c521-3d33-4ee1-aa23-bc5b4fc0b8cb)

![image](https://github.com/rachartier/dotfiles/assets/2057541/7abd0180-b034-49ed-b2aa-3b57a53af2aa)


