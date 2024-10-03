#!/bin/bash

script_path="$HOME/.config/scripts/copilot-cli"

# Launch the script with the path argument with the real current path
args=("$@")
for i in "${!args[@]}"; do
    if [ "${args[$i]}" == "--path" ]; then
        args[i + 1]="$(pwd)/${args[$i + 1]}"
        break
    fi
done

cd "$script_path" || exit

source ".venv/bin/activate"

python3 copilot-cli.py "${args[@]}"
deactivate
