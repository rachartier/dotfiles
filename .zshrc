source "$HOME/.profile"
source "$HOME/.dotfile_profile"

# WSL-appended /mnt/c dirs cost ~110 ms when zsh hashes $PATH; keep only explorer.exe and powershell.exe dirs.
typeset -U path
path=(${path:#/mnt/*} /mnt/c/WINDOWS /mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0)

ANTIDOTE_DIR="$HOME/.antidote"
[ ! -d $ANTIDOTE_DIR ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_DIR

zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

fpath=($ANTIDOTE_DIR/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Regenerate uv completions only when the uv binary changes.
() {
    local dir=$HOME/.zsh/completions uv=$HOME/.local/bin/uv
    fpath=($dir $fpath)
    [[ ! -x $uv || $dir/_uv -nt $uv ]] && return
    mkdir -p $dir
    $uv generate-shell-completion zsh >| $dir/_uv || rm -f $dir/_uv
    ${uv}x --generate-shell-completion zsh >| $dir/_uvx || rm -f $dir/_uvx
}

zstyle ':plugin:ez-compinit' 'use-cache' 'yes'
source ${zsh_plugins}.zsh

autoload -Uz promptinit && promptinit
prompt pure

# Insert a Python segment (psvar[24]) after Pure's git block.
PROMPT=${PROMPT/'%(21V.'/'%(24V. %F{yellow}%24v%f.)%(21V.'}

# Python version from $VIRTUAL_ENV, nearest .venv, or nearest .python-version; no subprocesses.
_pure_python_detect() {
  psvar[24]=
  local dir=$PWD cfg ver line

  if [[ -r $VIRTUAL_ENV/pyvenv.cfg ]]; then
    cfg=$VIRTUAL_ENV/pyvenv.cfg
  else
    while :; do
      if [[ -r $dir/.venv/pyvenv.cfg ]]; then
        cfg=$dir/.venv/pyvenv.cfg; break
      elif [[ -r $dir/.python-version ]]; then
        read -r ver < $dir/.python-version; break
      fi
      [[ $dir == / || $dir == $HOME ]] && break
      dir=${dir:h}
    done
  fi

  if [[ -n $cfg ]]; then
    while IFS= read -r line; do
      # uv writes "version_info = 3.12.4", stdlib venv writes "version = 3.12.4"
      [[ $line == version*=* ]] && { ver=${line##*= }; break; }
    done < $cfg
  fi

  ver=${ver#cpython-}; ver=${ver%%-*}
  [[ -n $ver ]] && psvar[24]=$''" v${ver}"   # Nerd Font python icon
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _pure_python_detect

function zsh_core_setup() {
    source $HOME/.aliases
    source $HOME/.zsh/style.zsh

    if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh --cmd cd)"
    fi

    if command -v fzf &> /dev/null; then
        source <(fzf --zsh)
    fi
}

zsh-defer zsh_core_setup

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[sudo]=none

setopt autocd                 # change directory just by typing its name
setopt auto_pushd             # make cd push old directory onto directory stack
setopt pushd_ignore_dups      # don't push duplicate directories onto the stack
setopt pushd_minus            # exchange meanings of '+' and '-' for directory stack
setopt pushd_silent           # do not print the directory stack after pushd or popd

setopt always_to_end          # cursor moved to the end in full completion
setopt complete_in_word       # allow completion from within a word/phrase
setopt listpacked             # make completion lists more densely packed
setopt nolisttypes            # disable showing completion types
setopt glob_dots              # include dotfiles in tab completion without leading dot

setopt extended_glob          # use extended globbing syntax
setopt no_case_glob           # case-insensitive globbing
setopt path_dirs              # perform path search even on commands with slashes
setopt interactivecomments    # allow comments in interactive shells

setopt long_list_jobs         # display PID when suspending processes

unsetopt BEEP                 # disable beep on error
unsetopt flow_control         # disable start/stop characters in shell editor

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 50000 ] && SAVEHIST=50000

setopt hist_ignore_all_dups   # ignore duplicated commands in history list
setopt hist_save_no_dups      # do not save duplicated commands
setopt hist_find_no_dups      # do not display duplicates when searching history
setopt hist_reduce_blanks     # remove superfluous blanks from history
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion before running it
setopt share_history          # share command history across sessions

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down

export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
