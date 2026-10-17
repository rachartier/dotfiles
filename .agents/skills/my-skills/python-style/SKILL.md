---
name: python-style
description: >-
  Python rules: uv, the ruff and ty check, data and module structure, I/O
  wiring, typing, docstrings and vertical spacing. Use when writing, editing or
  reviewing Python code.
---
# Python style

Apply the `code-design` skill first; this skill adds only what is specific
to Python. Like it, these rules apply to code you write or change.

## Tooling

Use uv unless the project uses another tool or you're told otherwise:
`uv add` for dependencies, `uv add --dev` for tooling.

Verify in this order:

1. Reread each function you wrote against Vertical spacing below.
2. If the project has a formatter, run it on the changed files.
3. Run `scripts/check.sh <changed files>` from this skill's folder: one ruff
   run with the project's rules plus this skill's annotation, docstring,
   syntax and size rules.
4. Run the project's type checker (`uvx ty check` when it has none).
5. Run the relevant tests with `uv run pytest`.

The check ignores D401 on purpose: it asks for imperative summaries and this
skill asks for descriptive ones ("Fetches…"). Never reword a summary to
satisfy it.

- Fix every finding on a line you wrote or changed. Leave findings on lines
  you didn't touch.
- C901 and PLR09xx findings are size signals: handle them as Size signals
  says, never with `# noqa`.

When you create a project, add the rules in
[references/pyproject.md](references/pyproject.md) to `pyproject.toml`.
Leave an existing project's ruff config as it is.

## Structure

- Data is a `@dataclass(frozen=True)`, or the project's model library.
- Name modules after their responsibility, never `utils.py`, `helpers.py`,
  `common.py`, `manager.py` or `misc.py`.
- Subclass at most one level below a Protocol or ABC.

### I/O and wiring

Put logic worth testing in functions that take data and return data, and do
the I/O around them (in `main` or the caller). Test those functions directly;
that needs no injection. The I/O code still gets a test: parse responses in a
pure function, and test the rest (requests, error handling, exit codes)
through the one seam.

Inject only when a test can't avoid the I/O otherwise, for example when the
logic and the I/O interleave (retries, polling, paging). Then add one seam per
I/O dependency, at the outermost function that needs it, and none below it:

- a single function: a keyword-only `Callable` parameter whose default is the
  real one;
- an object whose several methods you call (a client, a repository): a
  `Protocol` in the consuming module, with only those methods, passed through
  `__init__`.

No seam that no test uses, no DI framework, service locator or global
singleton. Tests pass small fakes instead of `mock.patch`-ing module paths.

In existing code, keep public signatures and constructors and test in the
project's current style (patching a stdlib seam such as `time.sleep` is
fine). Add a parameter to an existing signature only if it is the only way
to verify the change.

### Size signals

The check reports long functions, high complexity, many parameters and many
public methods (C901, PLR09xx); also take a second look at a class over ~150
lines. These are signals, not limits.

When one is crossed, check whether the unit still does one thing. If it
does (a cohesive public API, a dispatch table, a long but linear
procedure), keep it. If not and your change pushes it over, split it as
preparatory refactoring; otherwise report it in one line.

## Types

Follow the Google Python Style Guide (3.19), written with the newest syntax
the project's `requires-python` allows (3.12 when it sets none): built-in
generics, `X | None`, PEP 695 generics and `type` aliases (on older
versions, `TypeVar` and `TypeAlias`).

- Use `Self` when a method takes or returns its own type. A function whose
  body you change gets full annotations and a docstring, even if it had
  none; an existing docstring stays unless the change makes it wrong. Its
  neighbours stay as they are.
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
- Silence ty with its rule-specific comment: `# ty: ignore[rule]`.
- `if TYPE_CHECKING:` only to avoid a runtime import; an import cycle caused
  by typing is a design problem to fix first.

## Docstrings

Google style (3.8), always `"""`. The check enforces where they are
required; also document any non-obvious private function.

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

Function bodies are paragraphs: one blank line between steps (guards,
inputs, computation, side effects, result). The formatter never adds these
lines, so write them yourself, even when the surrounding code is dense.

- A step's lines stay together, and a call stays next to the check of its
  result.
- The body starts right after the `def` line or docstring, and a block's
  first and last lines touch its header and the next line.
- A multi-line `if`/`for`/`with`/`try` that is its own step has a blank
  line before and after it; bodies of three lines or fewer stay dense.
- Past about five paragraphs, extract a function.

```python
def export_report(path: Path, rows: Iterable[Row]) -> int:
    """Writes valid rows to a CSV report and returns how many."""
    if path.exists():
        raise FileExistsError(path)

    valid = sorted((row for row in rows if row.is_valid()), key=attrgetter("date"))

    with path.open("w", newline="") as f:
        csv.writer(f).writerows(row.as_tuple() for row in valid)

    return len(valid)
```
