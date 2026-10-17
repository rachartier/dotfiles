#!/usr/bin/env bash
# Usage: check.sh <changed files>
# The project's ruff rules plus python-style's annotation, docstring, syntax
# and size rules. D401 is off on purpose: python-style wants descriptive
# docstring summaries.
set -uo pipefail

status=0

uv run ruff check --output-format concise \
  --extend-select ANN,D,UP,PGH003,C90,PLR09 \
  --config 'lint.pydocstyle.convention = "google"' \
  --config 'lint.extend-per-file-ignores = {"**/test_*.py" = ["D", "ANN"], "**/conftest.py" = ["D", "ANN"]}' \
  --extend-ignore D401 \
  "$@" || status=$?

# PLR0904 is preview-only, and preview prints rule names instead of codes,
# so it runs on its own to keep codes in the main output.
uv run ruff check --preview --quiet --output-format concise \
  --select PLR0904 \
  --config 'lint.extend-per-file-ignores = {"**/test_*.py" = ["PLR0904"]}' \
  "$@" || status=$?

exit "$status"
