#!/usr/bin/env bash
# Usage: check.sh <changed files>
# The project's ruff rules plus python-style's annotation, docstring, syntax
# and size rules. D401 is off on purpose: python-style wants descriptive
# docstring summaries.
set -euo pipefail

exec uv run ruff check --preview \
  --extend-select ANN,D,UP,PGH003,C90,PLR09 \
  --config 'lint.pydocstyle.convention = "google"' \
  --config 'lint.extend-per-file-ignores = {"**/test_*.py" = ["D", "ANN"], "**/conftest.py" = ["D", "ANN"]}' \
  --config 'lint.mccabe.max-complexity = 8' \
  --config 'lint.pylint.max-statements = 30' \
  --config 'lint.pylint.max-public-methods = 7' \
  --extend-ignore D401 \
  "$@"
