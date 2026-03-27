#!/usr/bin/env bash

NOTES_DIR="$HOME/notes"

cd "$NOTES_DIR" || exit 1

git add -A

if git diff --cached --quiet; then
    exit 0
fi

git commit -m "Auto commit + push. $(date)"
git push
