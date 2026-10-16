---
name: python-style
description: >-
  Python-specific rules: uv tooling, data and module structure, I/O wiring, size
  signals, type annotations, docstrings and vertical spacing. Use before
  writing, editing or reviewing any Python code.
---
# Python style

Apply the `code-design` skill first; this skill adds only what is specific
to Python. Like it, these rules apply to code you write or change.

## Tooling

- Use uv unless the project uses another tool or you're told otherwise:
  `uv add` for dependencies, `uv add --dev` for tooling.
- Check with `uv run ruff check`, the project's type checker
  (`uvx ty check` when it has none), then the relevant tests with
  `uv run pytest`.

## Structure

- Data is a `@dataclass(frozen=True)`, or the project's model library.
- Define a `Protocol` in the module that consumes it, with only the methods
  that consumer calls.
- Name modules after their responsibility, never `utils.py`, `helpers.py`,
  `common.py`, `manager.py` or `misc.py`.
- Subclass at most one level below a Protocol or ABC.

### I/O and wiring

Logic worth testing on its own receives the collaborators that do I/O
through `__init__` or parameters, instead of creating them, opening
connections or files, or reading env or config. Wire concrete objects at the
program's entry point. A small script may call I/O directly. No DI
framework, service locator or global singleton. Tests pass small fakes that
implement the Protocol instead of `mock.patch`-ing module paths.

```python
class RateSource(Protocol):
    """A source of exchange rates."""

    def rate(self, currency: str) -> Decimal: ...


@dataclass(frozen=True)
class PriceConverter:
    """Converts prices between currencies."""

    rates: RateSource

    def convert(self, amount: Decimal, currency: str) -> Decimal:
        """Returns `amount` expressed in `currency`."""
        return amount * self.rates.rate(currency)


# At the entry point
converter = PriceConverter(rates=EcbRateSource(http_client))
```

### Size signals

These numbers prompt a second look; they are not limits: a module over ~300
lines; a class over ~150 lines or ~7 public methods; a function over ~30
statements, complexity over ~8, or more than ~5 parameters.

When one is crossed, check whether the unit still does one thing. If it
does (a cohesive public API, a dispatch table, a long but linear
procedure), keep it and give the reason in one line in your final report.
If not and your change pushes it over, split it as preparatory refactoring;
otherwise report it in one line. This advisory check lists them for the
files you changed. It never fails, and its thresholds don't go in the
project's config or in `# noqa` comments:

```bash
uv run ruff check --preview --select C90,PLR09 --exit-zero \
  --config 'lint.mccabe.max-complexity = 8' \
  --config 'lint.pylint.max-statements = 30' \
  --config 'lint.pylint.max-public-methods = 7' <changed files>
```

## Types

Follow the Google Python Style Guide (3.19), written with the newest syntax
the project's `requires-python` allows (3.12 when it sets none): built-in
generics, `X | None`, PEP 695 generics and `type` aliases (on older
versions, `TypeVar` and `TypeAlias`).

- Annotate every parameter and return type, but not `self` or `cls`. Use
  `Self` when a method takes or returns its own type.
- Annotate a variable only when the checker can't infer its type: an empty
  container, a `None` start, or a value assigned in branches.
- Accept wide, return narrow: parameters take the `collections.abc` type
  you actually use (`Mapping` if you only read); returns are concrete.
  Always parameterize generics: `Sequence[int]`, never bare `Sequence`.
- Before `Any`, try a type parameter, `object` or a `Protocol`. A kept
  `Any` gets `# noqa: ANN401 - <reason>`.
- Single-letter type parameters only when unconstrained and unbounded;
  otherwise a descriptive name. Type aliases are CapWords, `_Private` when
  module-only, and never an import shortcut.
- Decorators preserve signatures with `ParamSpec`
  (`def deco[**P, R](f: Callable[P, R]) -> Callable[P, R]`). Use
  `@overload` when the return type depends on the call form. Mark
  overriding methods with `@override`.
- Silence the type checker with its rule-specific comment
  (`# ty: ignore[rule]` for ty), never a bare `# type: ignore`, which
  ignores everything on the line.
- `if TYPE_CHECKING:` only to avoid a runtime import; an import cycle caused
  by typing is a design problem to fix first.

## Docstrings

Google style (3.8), always `"""`.

- Required on modules, public classes, public API and any non-obvious
  function. Skip trivial private helpers, `test_` functions (unless the
  setup is unusual) and `@override` methods that keep the base contract.
- Write for a caller who sees only the signature: semantics and side
  effects (e.g. mutates an argument), not implementation. Decorated
  functions describe their behavior after decoration.
- Summary in descriptive style ("Fetches rows…", not "Fetch…" or "This
  function…"). No types in `Args:`; the annotations have them. `Raises:`
  lists only exceptions callers should handle, not Fail Fast checks on API
  misuse.
- A class summary says what an instance represents ("The address of a
  cheese shop."); a `@property` is a noun phrase ("The table path.").

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

## Vertical spacing

Write function bodies as paragraphs of code: each group of lines is one
complete step (guard clauses, gathering inputs, the computation, side
effects, the result), with one blank line between steps. The formatter keeps
single blank lines but never adds them, so this is on you.

- Never two blank lines inside a function. No blank line inside a step,
  right after the `def` line or docstring, or at the start or end of an
  indented block. Keep a call next to the check of its result.
- A multi-line `if`/`for`/`with`/`try` that is its own step gets a blank
  line before and after it. Bodies of three lines or fewer stay dense.
- Past about five paragraphs, or when a paragraph needs a heading comment
  to be understood, extract a function.

```python
def export_report(path: Path, rows: Iterable[Row], *, overwrite: bool = False) -> int:
    """Writes valid rows to a CSV report, sorted by date.

    Returns:
        The number of rows written.

    Raises:
        FileExistsError: The report exists and `overwrite` is false.
    """
    if path.exists() and not overwrite:
        raise FileExistsError(path)

    valid = [row for row in rows if row.is_valid()]
    valid.sort(key=attrgetter("date"))

    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=HEADER)
        writer.writeheader()
        writer.writerows(row.as_dict() for row in valid)

    return len(valid)
```

