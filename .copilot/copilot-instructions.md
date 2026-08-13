# Copilot instructions

Comment rules apply to all languages; docstring rules are Python only. An
explicit instruction in the current prompt overrides anything here; otherwise
these are hard constraints.

## Comments

Default: none. Write one only if all three hold:

1. Not already clear from names, types, and structure.
2. Its absence could lead a reader to make a wrong change.
3. It describes the code as it is now, not how it got there.

Worth writing: why a non-obvious approach beat the obvious one; a constraint
from outside this file (API quirk, spec clause, upstream bug) with a link;
an invariant or edge case a reader would otherwise break; `TODO(owner): <action>`
pointing at a tracked issue.

- **C1** No restating code (`# increment counter`) and no narration or section
  headers (`# --- validation ---`). Extract a named function instead.
- **C2** No commented-out code. Delete it.
- **C3** No account of your own work: what you changed, what you tried, what the
  code was before, that a bug or a failing test existed. Holds in every form and
  position — block, trailing, docstring prose, a `Note:`/`Context:`/`History:`
  section, a parenthetical. Test: if a sentence only makes sense to someone who
  watched you write the code, delete it.
- **C4** Update or delete any comment whose code you change.

A justified comment is one line. If it needs a paragraph, it is a commit message.

```python
# Good: Upstream returns naive datetimes; see #412.
# Bad:  We parsed this as UTC before, which caused duplicate rows in prod, so...
```

## Python docstrings (Google style)

Write for the caller, who sees the signature and type hints and knows nothing
about the implementation or its history.

Required on public modules, classes, and functions. Skip private helpers,
self-explanatory one-liners, functions under ~3 lines with descriptive names,
and `__init__` methods that only assign arguments.

- **D1** Summary: one line, imperative mood, ends with a period. Blank line
  after it, always.
- **D2** Extended description only when it adds what the signature cannot.
- **D3** Never state types — type hints are the source of truth.
- **D4** Never restate the function name (`"""Initialize the class."""`) or open
  with filler ("This function is used to...", "Simply...").
- **D5** C3 applies here too. A docstring is not a changelog.
- **D6** Sections in order: `Args:` (meaning not type, omit when there are no
  parameters, never `self`/`cls`), then `Returns:` (omit when the return type is
  `None`) or `Yields:` for generators, then `Raises:` (exceptions a caller should
  handle, and what triggers each).

```python
def fetch_user(user_id: int, *, include_deleted: bool = False) -> User:
    """Retrieve a user by ID.

    Args:
        user_id: Primary key of the user to fetch.
        include_deleted: Whether to return soft-deleted records.

    Returns:
        The matching user.

    Raises:
        UserNotFoundError: If no user matches the given ID.
    """
```

## Skills

- **S1** `ponytail` and `caveman` are on by default. Load both at session start
  and apply them to every response — including short replies, follow-ups, tool
  turns, and error messages.
- **S2** Only an explicit user request turns one off. Turning off one does not
  affect the other, and it stays off for the rest of the session. Session
  length, context compaction, and topic changes do not deactivate them.
- **S3** Skills shape prose to the user. File contents follow the rules above.

<!-- rtk-instructions v2 -->
# RTK — Token-Optimized CLI
**rtk** is a CLI proxy that filters and compresses command outputs, saving 60-90% tokens.
## Rule
Always prefix shell commands with `rtk`:
```bash
# Instead of:              Use:
git status                 rtk git status
git log -10                rtk git log -10
cargo test                 rtk cargo test
docker ps                  rtk docker ps
kubectl get pods           rtk kubectl get pods
```
## Meta commands (use directly)
```bash
rtk gain              # Token savings dashboard
rtk gain --history    # Per-command savings history
rtk discover          # Find missed rtk opportunities
rtk proxy <cmd>       # Run raw (no filtering) but track usage
```
<!-- /rtk-instructions -->
