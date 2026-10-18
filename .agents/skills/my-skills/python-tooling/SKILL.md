---
name: python-tooling
description: >-
  Sets up a Python project's tooling (uv, ruff, ty, pytest, pre-commit) and,
  if the user wants one, a devcontainer. Use when the user starts a new Python
  project, or asks to update or reset an existing project's default config.
---

# Python project

The defaults are [templates/pyproject.toml](templates/pyproject.toml) (the
`[tool.*]` sections) and
[templates/pre-commit-config.yaml](templates/pre-commit-config.yaml) (the
hooks). To change a default, edit the template, not one project's copy.

## New project

1. `uv init --package <name>` (src layout, git repo). Raise
   `requires-python` to `>=3.12` if uv set it lower, or set the version the
   user names; ruff and ty read their target version from it.
2. `uv add --dev ruff ty pytest`.
3. Append `templates/pyproject.toml` to `pyproject.toml`. Give the generated
   `__init__.py` and its `main` docstrings, and create
   `tests/test_<name>.py` with one smoke test that calls `main()`.
4. Copy `templates/pre-commit-config.yaml` to `.pre-commit-config.yaml`,
   then `uvx pre-commit install`.
5. Ask whether the project needs a devcontainer. If yes, set it up with the
   `capsule` skill.

## Updating an existing project

1. Read the project's ruff, ty and pytest config (`pyproject.toml` or
   `ruff.toml`) and `.pre-commit-config.yaml`, and diff them against the
   templates.
2. Show the user each difference grouped as: missing defaults to add,
   project settings that differ from the defaults, and project-only
   settings. Add the missing defaults; change or remove anything else only
   for the items the user approves.
3. Add any missing dev dependency with `uv add --dev`, and install hooks as
   in New project step 4 if the project had none.
4. Run `uv run ruff check --statistics`, `uv run ruff format --check` and
   `uv run ty check`. The new config usually surfaces findings in code
   nobody touched: report the counts per rule and ask the user which to fix.
   `uv run ruff check --fix` applies the safe fixes.
5. Ask about a devcontainer as in New project step 5, unless the project
   already has `.devcontainer/`.

## Done

The project is set up when `uv run ruff check`, `uv run ruff format --check`,
`uv run ty check` and `uv run pytest` pass, and on a new project
`uvx pre-commit run --all-files` too. On an update, list the findings the
user chose to leave instead.
