# Dotfiles

Full installation
--------------------

```
export GIT_CLONE_METHOD=ssh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

Inside a docker installation
--------------------

```
export DOTFILES_MINIMAL=1 
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

# Testing inside a docker:

Launch a docker container: 
```
docker run --privileged  -ti ubuntu:22.04 /bin/bash
```

When inside, create a user:
```
apt update && apt install -y curl sudo && yes | useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' 'test') dotfilesuser && usermod -aG sudo dotfilesuser && su dotfilesuser
```

Finally, install the dotfiles:
```
export DOTFILES_MINIMAL=1 
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/scripts/first_install.sh)"
```

And type `zsh` when all is finished.


# Images

![image](https://github.com/rachartier/dotfiles/assets/2057541/84147121-17c3-4234-a2b0-a278458c78c7)

![image](https://github.com/rachartier/dotfiles/assets/2057541/97b1d57f-93ac-4462-9963-89831e9987e9)

![image](https://github.com/rachartier/dotfiles/assets/2057541/4de1e93a-e167-4bd1-8786-d28172e56e6a)
