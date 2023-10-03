#!/bin/bash

tree_mode()
{
  highlight="${1}"
  tmux ls -F'#{session_id}' | while read -r s; do
    S=$(tmux ls -F'#{session_id}#{session_name}: #{T:tree_mode_format}' | grep ^"$s")
    session_info=${S##$s}
    # session_name=$(echo "$session_info" | cut -d ':' -f 1)

    if [[ -n "$highlight" ]] && [[ "\$$highlight" == "$s" ]]; then
      echo -e "$(tput setaf 4)$session_info\033[0m"
    else
        echo -e "$(tput bold setaf 7)$session_info\033[0m"
    fi
    # Display each window
    tmux lsw -t"$s" -F'#{window_id}' | while read -r w; do
      W=$(tmux lsw -t"$s" -F'#{window_id}#{T:tree_mode_format}' | grep ^"$w")
      echo -e "$(tput setaf 0)  ﬌ ${W##$w}\033[0m"
    done
  done
}

echo $1
tree_mode $1
