---
name: python-style
description: >-
  Python-specific rules - uv tooling, code structure (Zen of Python, functions
  vs classes, inheritance, I/O wiring, size signals), type annotations,
  Google-style docstrings and vertical spacing. Use before writing, editing or
  reviewing any Python code, after the code-design skill.
---
# Python style

Apply the `code-design` skill first; this skill only adds what is specific
to Python. Like it, these rules apply to code you write or change, not to
code you only read.

## Tooling

- Unless instructed otherwise, use uv as the environment and package
  manager. Add dependencies with `uv add` (`uv add --dev` for tooling).
- Verify with `uv run ruff check`, then the relevant tests with
  `uv run pytest`.

## Structure

### Zen of Python

Apply PEP 20 (`import this`) as working rules:

- *Explicit is better than implicit*: pass dependencies and data as
  arguments; no hidden globals, import-time side effects or magic
  registration.
- *Simple is better than complex. Complex is better than complicated*:
  plain functions and data first; build truly complex things from simple
  parts, not one clever mechanism.
- *Flat is better than nested*: early returns over nested `if`s, a flat
  package over deep sub-packages.
- *Readability counts*: names from the domain, one idea per line, no
  cleverness that needs a comment to decode.
- *There should be one obvious way to do it*: use the idiom the standard
  library and the project already use, not a second way of your own.

### Functions, classes and modules

- Start with a function. Make it a class only when state must live across
  calls. Data is a `@dataclass(frozen=True)` (or the project's model
  library). No classes made only of static methods: that's what modules are
  for.
- Add a `Protocol` only at an I/O boundary you fake in tests, or when two
  implementations exist today. Keep it to the methods its consumer calls,
  defined in the consumer's module.
- Variants that differ only by data are a dataclass field or a dict. A set
  of variants that keeps growing is a dict of functions, not a class
  hierarchy or plugin mechanism.
- Name modules after their responsibility (`invoice_pricing.py`). Never
  `utils.py`, `helpers.py`, `common.py`, `manager.py` or `misc.py`.
- Keep a feature readable in one or two files. A short function lives next
  to its caller unless it is a separate responsibility.
- To split a class, group its methods by the attributes they use; each group
  becomes its own class or module.
- Common things not to hand-roll: retries, CLI parsing, date handling,
  data validation, HTTP clients, file format parsing. Check the standard
  library (`dataclasses`, `enum`, `functools`, `itertools`, `pathlib`,
  `contextlib`, `argparse`, `logging`…) first.

### Inheritance

- Liskov substitution: a subclass must work anywhere its parent does. An
  override accepts the same arguments, returns the same type and raises no
  new exceptions. A subclass that raises `NotImplementedError` for an
  inherited method shouldn't be a subclass.
- Prefer composition. Subclass only to share implementation, never more
  than one level below a Protocol or ABC.

### I/O and wiring

- Logic worth testing on its own receives the collaborators that do I/O
  through `__init__` or parameters, instead of creating them, opening
  connections or files, or reading env or config. Wire concrete objects at
  the program's entry point. A small script may just call I/O directly. No
  DI framework, service locator or global singleton.
- No import cycles; a cycle means a responsibility is in the wrong module.

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
converter: PriceConverter = PriceConverter(rates=EcbRateSource(http_client))
```

Tests pass small fakes that implement the Protocol instead of
`mock.patch`-ing module paths.

### Size signals

These numbers are prompts to look again, not limits:

- Module over ~300 lines.
- Class over ~150 lines or ~7 public methods.
- Function over ~30 statements, complexity over ~8, or more than ~5
  parameters.

Crossing one means checking whether the unit still does one thing. If it
does (a cohesive public API, a dispatch table, a long but linear
procedure), keep it and give the reason in one line in your final report.
If not and your change is what pushes it there, split it as preparatory
refactoring; otherwise report it in one line. To find them in the files
you changed, run this advisory check; it never fails, and its thresholds
don't go in the project's config or in `# noqa` comments:

```bash
uv run ruff check --preview --select C90,PLR09 --exit-zero \
  --config 'lint.mccabe.max-complexity = 8' \
  --config 'lint.pylint.max-statements = 30' \
  --config 'lint.pylint.max-public-methods = 7' <changed files>
```

## Types

Follow the Google Python Style Guide (section 3.19), written with the newest
syntax the project's `requires-python` allows (3.12 when it sets none):
built-in generics, `X | None`, PEP 695 generics and `type` aliases (on older
versions, `TypeVar` and `TypeAlias`).

- Annotate every variable you write, locals included, whenever Python's
  syntax allows it, even when the type could be inferred. Only loop
  targets, comprehension variables and `with ... as` targets stay bare, since
  they can't be annotated inline. Annotate every function's parameters and
  return type; don't annotate `self` or `cls`, and use `Self` when a method
  takes or returns its own type.
- Accept wide, return narrow: parameters take the abstract `collections.abc`
  type you actually use (`Mapping` if you only read); returns are concrete.
  Always parameterize generics: `Sequence[int]`, never bare `Sequence`.
- Before `Any`, try a type parameter, `object` or a `Protocol`. A kept `Any`
  gets `# noqa: ANN401 - <reason>`.
- Single-letter type parameters only when unconstrained and unbounded;
  otherwise a descriptive name. Type aliases are CapWords, `_Private` when
  module-only, and never an import shortcut.
- Decorators preserve signatures with `ParamSpec`
  (`def deco[**P, R](f: Callable[P, R]) -> Callable[P, R]`). Use `@overload`
  when the return type depends on the call form. Mark overriding methods with
  `@override`.
- Silence a checker with a specific code (`# type: ignore[code]`), never a
  bare ignore or a `# type:` comment.
- `if TYPE_CHECKING:` only to avoid a runtime import; an import cycle caused
  by typing is a design smell to fix first.

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

## Vertical spacing

Follow PEP 8 "Blank Lines" ("use blank lines in functions, sparingly, to
indicate logical sections") and Clean Code ch. 5: *vertical openness*
between concepts, *vertical density* within one. Write function bodies as
*paragraphs of code*: each group of lines is one complete step, and a
blank line marks where the next step begins. The formatter keeps single
blank lines but never adds them, so this is on you.

- Split a body into its steps: guard clauses, gathering inputs, the
  computation, side effects (I/O, mutation), the result. One blank line
  between steps; never two inside a function.
- No blank line inside a paragraph. Keep a variable next to its first use,
  and a call next to the check of its result (`x = f()` then
  `if x is None:` stay together).
- Leave a blank line after the guard-clause block (early `raise`/`return`)
  before the main logic.
- A multi-line `if`/`for`/`with`/`try` that is its own step gets a blank
  line before and after it.
- Separate the final `return` with a blank line when it follows a
  multi-line paragraph. Bodies of three lines or fewer stay dense.
- No blank line right after the `def` line or the docstring, nor at the
  start or end of an indented block.
- A paragraph may open with a one-line comment when the step isn't obvious
  from the code; don't label every paragraph.
- Blank lines don't replace extraction: past ~5 paragraphs, or when a
  paragraph needs a heading comment to be understood, extract a function.
- Module level: two blank lines around top-level `def`/`class`, one between
  methods; extra blank lines (sparingly) to group related functions.

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

    valid: list[Row] = [row for row in rows if row.is_valid()]
    valid.sort(key=attrgetter("date"))

    with path.open("w", newline="") as f:
        writer: csv.DictWriter[str] = csv.DictWriter(f, fieldnames=HEADER)
        writer.writeheader()
        writer.writerows(row.as_dict() for row in valid)

    return len(valid)
```

