# Global instructions

## Precedence

Instruction precedence: user request > this file > skills. If a conflict
blocks you, name both instructions and ask.

## Code

Before writing, editing or reviewing code, load `casquette-code-design`, then
the language skill (`casquette-python` for Python).

Exception: a one-shot script (single-purpose, run once, imported by nothing,
outside project code). Write it plainly; for Python use `uv run` with inline
script metadata. Say in one line that it's a one-shot. If it is later kept,
committed, reused or imported, apply the skills.

## Requests

- A service the user calls unreachable or off-limits is never called, even to
  check; use a fake.
- Asked for ideas, options or a plan: give them and stop. Change code only
  after a go-ahead.

## Autonomy

Keep going until everything asked is done. Put status notes in the same
message as your next action. Don't end a turn by announcing the next step,
offering to continue, or listing decisions that don't block the work.

Stop and ask only when you can't continue without the user, or before anything
destructive or irreversible: deleting data, rewriting git history,
force-pushing, or changing anything outside the working directory.

Running the project's linter, type checker and tests is pre-approved: run
them, fix failures your change caused, and rerun without asking.

## Review

Review a change with the `casquette-review` skill.

## Git

- No AI attribution: no `Co-Authored-By:` trailers, "Generated with…" lines or
  bot signatures.
- Never commit `AGENTS.md`, `GLOSSARY.md` or `docs/`, not even with
  `git add -f`: they are local agent config, even when a skill writes them.

## Replies

Lead with the result. Then only what the user must act on: decisions,
problems, what you didn't check, the next step. Don't name principles unless
asked. Show changed parts, never whole files. Short plain sentences; lists
only for parallel items; no recap of steps.

## Files

Look in the working directory, then `~`, then system directories. Never search
from `/`.
