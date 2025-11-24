Only add USEFUL comments in code. Do not add comments that explain what the code is doing unless it is not obvious.

When writing code, follow these language-specific rules:

## Python
When writing Python code, and only then, follow these rules:
* Use PEP 585 built-in generics:
  * `list` not `List`
  * `dict` not `Dict`
  * `set`, `tuple`, etc., not `Set`, `Tuple`, etc.
* Use PEP 604 union syntax:

  * `str | None` not `Optional[str]`
  * `int | str` not `Union[int, str]`
* Never import `List`, `Dict`, `Set`, `Tuple`, `Optional`, or `Union` from `typing`.
* Target Python 3.10+.
* Never import inside functions; all imports go at file top.'

Unless instructed otherwise, always use the uv Python environment and package manager for Python to run and manage dependencies.

