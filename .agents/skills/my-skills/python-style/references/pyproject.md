# Ruff rules for a new project

Add to `pyproject.toml` so editors and CI enforce python-style's rules:

```toml
[tool.ruff.lint]
extend-select = ["ANN", "D", "UP", "PGH003"]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.lint.per-file-ignores]
"**/test_*.py" = ["D", "ANN"]
"**/conftest.py" = ["D", "ANN"]
```
