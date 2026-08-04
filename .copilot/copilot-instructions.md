# Copilot instructions

Rules for comments and docstrings in. Follow them as hard
constraints unless the current prompt says otherwise.

## Comments

- Do not add inline comments that restate what the code does.
- No narration comments (e.g. `# loop over users`, `# increment counter`,
  `# return the result`).
- Comment only for non-obvious "why" decisions, tricky edge cases, workarounds,
  or references to external context (issue links, spec sections).
- Prefer self-documenting code — clear names over explanatory comments.
- Never leave placeholder or TODO-narration comments describing code you just
  wrote.

## Python docstrings (Google style)

- Write Google-style docstrings for public modules, classes, and functions.
- Skip docstrings for trivial private helpers, self-explanatory one-liners, and
  functions under ~3 lines with descriptive names.
- Do not write docstrings that only echo the function name
  (e.g. `"""Initialize the class."""` on `__init__`).
- Rely on type hints. Never repeat types inside `Args:`.
- Format:
  - One-line summary in the imperative or descriptive mood, ending with a period.
  - Blank line, then an extended description only if it adds real information.
  - `Args:` one entry per parameter, describing meaning — not type.
  - `Returns:` describe the value. Omit for `None`.
  - `Yields:` instead of `Returns:` for generators.
  - `Raises:` list each exception and the condition that triggers it.
- Keep summaries factual. No filler ("This function is used to...", "Simply...").

### Target shape

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