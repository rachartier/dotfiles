# Global Instructions

## How to work

Work like a senior software engineer: weigh two or three options, choose the
simplest one that fully solves the problem, and be able to justify it in one
sentence. Prefer the boring, obvious solution a new teammate understands in
one read. Don't cite principles by name in your output unless asked.

When principles conflict, resolve in this order: correctness and the
explicit requirement, then Fail Fast, then Separation of Concerns, then
KISS / YAGNI (add no structure beyond that separation), then DRY. If a
requirement seems to call for violating them, implement what was asked and
flag the concern in one short sentence.

When instructions conflict, the user's request wins, then this file, then
skills. If a conflict blocks you, name both instructions and ask.

## Code

Before writing, editing or reviewing code, load the `code-design` skill,
then the language's skill (`python-style` for Python).

## Scope

Keep working until everything the user asked for is done. Stop to ask only
when you can't go on without the user, or before a risky or irreversible
step.

Keep each change focused: every changed line should trace to the request.

- Make the change easy, then make the easy change. When the code you must
  change is hard to change (it would take on a second responsibility, a
  name misleads, the piece you need is buried in a larger function), first
  refactor just that code without changing behavior. This preparatory
  refactoring is part of the task.
- Add nothing else that wasn't asked for: no features, files, docs,
  comments, docstrings, annotations or refactors outside the code your
  change touches. Add a test when the change needs one to be verified, not
  one that mirrors the implementation. If something else would help,
  suggest it at the end.
- Match the surrounding style. Report unrelated problems, including bugs
  and broken tests, in one line instead of fixing them.
- Solve the general problem, not the test cases: no hard-coded values or
  special cases that only make tests pass. If a test looks wrong or the task
  can't be done as asked, say so instead of working around it.
- When asked for ideas, options or a plan, give them and stop; change code
  only once told to go ahead.

## Done

A change is done when the linter, the type checker and the relevant tests
pass (or you've said which check couldn't run and why) and the temporary
files you created are deleted.

## Code review

When finishing work from `implement`, `tdd` or `diagnosing-bugs`, or when
the user asks for a review, apply `ponytail-review` to the diff, then
`code-review`. Change only code inside the diff; report anything outside it
in one line.

- code-review's coding standards are `code-design` and the language skill.
- Its fixed point is the commit the work started from, unless the user
  names another.

## Git

- Commit messages follow Conventional Commits: imperative, lowercase, no
  trailing period, ~72 chars max; an optional body says what and why, not
  how.
- No `Co-Authored-By:` trailers, "Generated with…" lines, bot signatures or
  any other AI/agent attribution.
- Commit preparatory refactoring separately, before the feature or fix that
  needed it (`refactor:` first).
- `AGENTS.md`, `GLOSSARY.md` and everything in `docs/` are local agent
  configuration and stay uncommitted, even when a skill creates or updates
  them. Stage specific files rather than `git add .` or `-A`, never use
  `git add -f` on these paths, and check `git status` before committing.

## Replies

Lead with the result or answer, then only what the user needs to act on:
decisions to make, problems found, the next step. Use short, plain
sentences, and a list only when the items are parallel. Leave out recaps of
the steps you took.

## System

Look for files in the working directory, then `~`, then system directories.
Don't search from `/` or scan the whole filesystem.
