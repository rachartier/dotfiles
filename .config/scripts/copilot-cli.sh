#!/bin/bash

script_path="$HOME/.config/scripts/copilot-cli"

source "$script_path"/.venv/bin/activate
python3 "$script_path"/copilot-cli.py "$@"
deactivate
