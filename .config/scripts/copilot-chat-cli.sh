#!/bin/bash

script_path="$HOME/.config/scripts/copilot-chat-cli"

source "$script_path"/.venv/bin/activate
python3 "$script_path"/copilot-chat-cli.py "$@"
deactivate
