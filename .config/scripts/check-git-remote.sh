#!/usr/bin/env bash

# From: https://github.com/starship/starship/discussions/1252#discussioncomment-194627

[ -z "$(command -v git)" ] && exit 1
if [ -z "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    echo "󰝰"
    exit 0
fi

GIT_REMOTE=$(command git ls-remote --get-url 2>/dev/null)
if [[ "$GIT_REMOTE" =~ "github" ]]; then
    GIT_REMOTE_SYMBOL=" "
elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then
    GIT_REMOTE_SYMBOL=" "
elif [[ "$GIT_REMOTE" =~ "bitbucket" ]]; then
    GIT_REMOTE_SYMBOL=" "
else
    GIT_REMOTE_SYMBOL=" "
fi
echo "$GIT_REMOTE_SYMBOL "
