# Copilot instructions

An explicit instruction in the current prompt overrides these rules.
Ruff (pyproject.toml) enforces Python annotations, generics and docstring
format: run `ruff check` on Python files you touch and fix what it reports.

## Git

Never run `git add`, commit, or push.

## Scope and cost

- Change only what the request needs. No drive-by refactors, renames or
  reformatting; match the surrounding style. Report other problems in one
  line instead of fixing them.
- Read only the files the task touches. Show diffs or changed parts, never
  whole files back.
- Clear request: finish it without asking for confirmation. Ambiguous one:
  ask once, up front.
- Verify once at the end (ruff, then the relevant tests), not after every edit.

## Comments (all languages)

Comment like a good senior developer: rarely, one short line, plain words.
Say why, never what, and never how you got here. Keep comments true when the
code changes.

```python
# Good: API returns naive datetimes; treat as UTC (#412).
# Bad:  loop over users / changed this to fix the bug
```

## Python types (3.12+)

Write `list[str]`, `X | None`, PEP 695 generics and `type` aliases from the
start. Beyond what ruff checks:

- Accept wide, return narrow: parameters take the `collections.abc` protocol
  you actually use (`Mapping` if you only read); returns are concrete.
- Before `Any`, try `object`, a type parameter, or a `Protocol`. A kept `Any`
  gets `# noqa: ANN401 - <reason>`.
- Decorators preserve signatures with `ParamSpec`. Use `@overload` when the
  return type depends on the call form.

## Python docstrings (Google)

Write for a caller who sees only the signature. Never repeat types, restate
the name, or open with filler ("This function..."). `Args:` gives meaning,
not type. `Raises:` lists exceptions a caller should handle and their trigger.

## Skills

- Load `ponytail` and `caveman` at session start. Apply both to every
  response: short replies, follow-ups, tool turns, error reports.
- Only an explicit user request turns one off; the other stays on. Session
  length, compaction and topic changes never turn them off.
- They shape prose to the user only. File contents follow the rules above.
