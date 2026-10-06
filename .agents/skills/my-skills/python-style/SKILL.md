---
name: python-style
description: >-
  Type annotation and Google-style docstring rules for Python 3.12+. Load before
  writing, editing or reviewing any Python code.
---
# Python style

## Types

Follow the Google Python Style Guide (section 3.19), written with 3.12 syntax.
Beyond what ruff checks:

- Annotate every public API. Don't annotate `self` or `cls`; use `Self` when a
  method takes or returns its own type.
- Use built-in generics and `|`: `list[str]`, `X | None`. Never import `List`,
  `Dict`, `Set`, `Tuple`, `Optional` or `Union` from `typing`. Import typing
  symbols directly: `from collections.abc import Mapping, Sequence`.
- A parameter that can be `None` is declared `X | None`; never `x: str = None`.
- Accept wide, return narrow: parameters take the abstract `collections.abc`
  type you actually use (`Mapping` if you only read); returns are concrete.
- Always parameterize generics: `Sequence[int]`, never bare `Sequence`.
- Before `Any`, try a type parameter, `object` or a `Protocol`. A kept `Any`
  gets `# noqa: ANN401 - <reason>`.
- Generics use PEP 695 syntax: `def first[T](items: Sequence[T]) -> T`.
  Single-letter type parameters only when unconstrained and unbounded;
  otherwise a descriptive name.
- Aliases use `type Name = ...`, CapWords, `_Private` when module-only. Never
  use an alias as an import shortcut.
- Decorators preserve signatures with `ParamSpec`
  (`def deco[**P, R](f: Callable[P, R]) -> Callable[P, R]`). Use `@overload`
  when the return type depends on the call form. Mark overriding methods with
  `@override`.
- Annotate a variable only when its type can't be inferred. No `# type:`
  comments; silence a checker with a specific code (`# type: ignore[code]`).
- All imports go at file top, except to break a circular import.
  `if TYPE_CHECKING:` only to avoid a runtime import; a cycle caused by typing
  is a smell to refactor first.

## Docstrings

Follow the Google Python Style Guide (section 3.8). Always `"""`.

- Required on modules, public classes, public API and any non-trivial or
  non-obvious function. Skip trivial private helpers, `test_` functions
  (unless the setup is unusual) and `@override` methods that keep the
  base contract.
- Summary: one line ending with a period, descriptive style ("Fetches rows
  from…", not "Fetch…" or "This function…"). Then a blank line and details
  only if needed.
- Write for a caller who sees only the signature: semantics and side effects
  (e.g. mutates an argument), not implementation; that belongs in comments.
  Decorated functions describe their behavior after decoration.
- Sections, in this order, with a 4-space hanging indent. Omit any the
  summary already covers:
  - `Args:` `name: meaning.` No types; the annotation has them. List `*args`
    and `**kwargs` with their stars.
  - `Returns:` (`Yields:` for generators, describing what `next()` gives):
    what the value means. Omit for `None`, or when the summary starts with
    "Returns…" and says enough. Tuples: "A tuple (a, b), where a is…".
  - `Raises:` `ExcType: condition.` Only exceptions callers should handle,
    not the precondition errors raised by Fail Fast checks on API misuse.
- Classes: the summary says what an instance represents ("The address of a
  cheese shop.", not "Class that…"). Exceptions say what they represent, not
  when they're raised. Public attributes (not properties) go in
  `Attributes:`; `__init__` documents its `Args:`.
- `@property`: a noun phrase like an attribute ("The table path."), not
  "Returns the…".

```python
def fetch_rows(table: Table, keys: Sequence[str]) -> Mapping[str, Row]:
    """Fetches rows from a table.

    Args:
        table: An open table handle.
        keys: Keys of the rows to fetch. Missing keys are skipped.

    Returns:
        A mapping from each found key to its row.

    Raises:
        ConnectionError: The table is unreachable.
    """
```

