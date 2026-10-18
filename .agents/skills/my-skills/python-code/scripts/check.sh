#!/usr/bin/env bash
# Usage: check.sh <changed files>
# The project's ruff rules plus python-code's annotation, docstring, syntax
# and size rules. D401 is off on purpose: python-code wants descriptive
# docstring summaries.
set -euo pipefail

exec uv run ruff check --output-format concise \
  --extend-select ANN,D,UP,PGH003,C90,PLR09 \
  --config 'lint.pydocstyle.convention = "google"' \
  --config 'lint.extend-per-file-ignores = {"tests/**" = ["D", "ANN"], "**/test_*.py" = ["D", "ANN"], "**/conftest.py" = ["D", "ANN"]}' \
  --extend-ignore D401 \
  "$@"
