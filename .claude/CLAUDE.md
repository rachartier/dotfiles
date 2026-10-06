# Global instructions

## Engineering principles

Apply these principles to every piece of code or instructions you write or modify. They describe how to work, not extra deliverables: never mention them in your output unless asked.

1. **KISS / YAGNI**: Simplest solution that fully meets the requirement. Implement only what is explicitly requested; no speculative features, options or abstraction layers.

1. **DRY**: Avoid duplicating business logic. Tolerate small, incidental repetition rather than introducing a premature abstraction.

1. **Separation of Concerns**: Keep I/O, business logic, orchestration, and presentation in distinct functions or modules. Business logic should be testable without touching the network, filesystem, or UI.

1. **High Cohesion, Low Coupling**: Group code that changes for the same reason. Minimize dependencies between modules and expose narrow, explicit interfaces.

1. **Fail Fast**: Validate inputs and preconditions at the boundary. When state is invalid, raise a clear, specific error immediately. Never swallow exceptions, return silent defaults, or add fallbacks that hide failures.

### When principles conflict

Resolve in this order:
1. Correctness and the explicit requirement
2. Fail Fast
3. KISS and YAGNI
4. Separation of Concerns and cohesion/coupling
5. DRY

If a requirement seems to call for violating these principles, implement what was asked and flag the concern in one short sentence.

## Scope and cost

- Change only what the request needs. No drive-by refactors, renames or
  reformatting; match the surrounding style. Report other problems in one
  line instead of fixing them.
- Read only the files the task touches. Show diffs or changed parts, never
  whole files back.
- Clear request: finish it without asking for confirmation. Ambiguous one:
  ask once, up front.
- Verify once at the end (`uv run ruff check`, then the relevant tests with
  `uv run pytest`), not after every edit, unless a skill such as /tdd
  defines its own test loop.

## System

- Never search from `/`. Look in the working directory, then `~`, then
  system directories. Never scan the entire filesystem.

## Git

- Write commit messages following the Conventional Commits spec:
  `<type>(<optional scope>): <description>`
  - Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
  - Description: imperative mood, lowercase, no trailing period, max ~72 chars
  - Optional body after a blank line explaining what and why, not how
  - Breaking changes: add `!` after the type/scope and a `BREAKING CHANGE:` footer
- Never add `Co-Authored-By:` trailers or any AI/agent attribution to commit messages.
- No "Generated with…" lines, no bot signatures, no emojis crediting the agent.

## Comments (all languages)

Comment like a good senior developer: rarely, one short line, plain words.
Say why, never what, and never how you got here. Keep comments true when the
code changes. Do not add section comments that designate areas.

```python
# Good: API returns naive datetimes; treat as UTC (#412).
# Bad:  loop over users / changed this to fix the bug
```

## Python

- Before writing, editing or reviewing Python, load the `python-style` skill.
- Unless instructed otherwise, always use uv as the Python environment and
  package manager.

## Skills

- Load `ponytail` and `caveman` at session start if they are not already
  active. Keep both on for the whole session: session length, compaction and
  topic changes never turn them off. Only an explicit user request turns one
  off; the other stays on.
- Caveman applies to chat replies only, never to code, comments, docstrings
  or commit messages. Keep its built-in exceptions (security warnings,
  irreversible actions).

## Code review

- When finishing work from /implement, /tdd or /diagnosing-bugs, run
  /ponytail-review on the diff before /code-review. Apply its deletions
  only within the diff; report anything outside it in one line.
