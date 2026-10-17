#!/usr/bin/env bash
# Symlink every skill under ~/.agents/skills (any depth) flat into ~/.claude/skills.
# A "skill" is any directory containing a SKILL.md.
#
# Usage: link-skills.sh [-n]   (-n = dry run)
# Override paths with SRC=... DST=... env vars.

set -euo pipefail

SRC="${SRC:-$HOME/.agents/skills}"
DST="${DST:-$HOME/.claude/skills}"
DRY=0
[[ "${1:-}" == "-n" ]] && DRY=1

run() { if ((DRY)); then echo "  [dry] $*"; else "$@"; fi; }

[[ -d "$SRC" ]] || {
    echo "No source dir: $SRC" >&2
    exit 1
}

# If DST is itself a symlink (e.g. to SRC), replace it with a real dir.
if [[ -L "$DST" ]]; then
    echo "Replacing symlinked $DST with a real directory"
    run rm "$DST"
fi
run mkdir -p "$DST"

# Drop stale links we created earlier (pointing into SRC but now broken).
if [[ -d "$DST" ]]; then
    for l in "$DST"/*; do
        [[ -L "$l" ]] || continue
        target=$(readlink "$l")
        if [[ "$target" == "$SRC"/* && ! -e "$l" ]]; then
            echo "Removing stale link: $(basename "$l")"
            run rm "$l"
        fi
    done
fi

linked=0 skipped=0
seen=$'\n' # newline-separated names (no assoc arrays: macOS ships bash 3.2)

while IFS= read -r -d '' skillmd; do
    dir=$(dirname "$skillmd")
    rel=${dir#"$SRC"/}
    name=$(basename "$dir")

    # Leaf name collides with another skill in this run? use the full path, dashed.
    if [[ "$seen" == *$'\n'"$name"$'\n'* ]]; then
        name=${rel//\//-}
    fi
    seen+="$name"$'\n'

    link="$DST/$name"

    if [[ -L "$link" ]]; then
        if [[ "$(readlink "$link")" == "$dir" ]]; then
            continue # already correct
        fi
        echo "Relinking $name -> $rel"
        run ln -sfn "$dir" "$link"
    elif [[ -e "$link" ]]; then
        echo "SKIP $name: a real file/dir already exists at $link" >&2
        ((skipped++)) || true
        continue
    else
        echo "Linking $name -> $rel"
        run ln -s "$dir" "$link"
    fi
    ((linked++)) || true
done < <(find "$SRC/" -name SKILL.md -type f -print0 | sort -z)

echo "Done: $linked linked/updated, $skipped skipped. Restart Claude Code to pick them up."
