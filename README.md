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

# Images

![image](https://github.com/rachartier/dotfiles/assets/2057541/84147121-17c3-4234-a2b0-a278458c78c7)

![image](https://github.com/rachartier/dotfiles/assets/2057541/97b1d57f-93ac-4462-9963-89831e9987e9)

![image](https://github.com/rachartier/dotfiles/assets/2057541/4de1e93a-e167-4bd1-8786-d28172e56e6a)
