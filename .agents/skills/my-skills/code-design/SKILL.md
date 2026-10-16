---
name: code-design
description: >-
  Language-agnostic design rules for code: simplicity tests, what counts as
  over-engineering, how to design a change, how to choose third-party libraries,
  and how to comment. Use before writing, editing or reviewing code in any
  language.
---
# Code design

These rules apply to code you write or change. When reviewing, apply them to
the diff, not to the code around it.

## Principles

- **KISS / YAGNI**: before adding an abstraction, name the second concrete
  use that needs it today. If there is none, don't add it.
- **Reuse before writing**: reach, in this order, for the standard library,
  code the project already has, a dependency already installed, then a new
  library that passes Dependencies below. Write it yourself only when none
  fits, or when the library would weigh more than the few clear lines it
  replaces.
- **Separation of Concerns**: keep I/O, business logic, orchestration and
  presentation apart, so business logic is testable without the network,
  filesystem or UI. Split by responsibility, never to shorten a file.
- **DRY**: tolerate small, incidental repetition rather than a premature
  abstraction.
- **Fail Fast**: validate at the boundary (user input, external systems) and
  raise a specific error immediately. Don't swallow exceptions, return
  silent defaults or add fallbacks that hide failures. Don't handle cases
  that can't happen inside your own code.
- **CUPID** is the everyday check for every module, class and function:
  composable (small surface, few dependencies), does one thing well,
  predictable (does what its name says, no hidden side effects, loud
  failures), idiomatic in the language and the project, and named after the
  problem domain rather than technical categories or pattern names.

## Over-engineering

Simple means easy to read and change, not few files or few lines. A module
that owns one responsibility is fine. These are not:

- an interface or base class with a single implementation (a test fake at
  an I/O boundary counts as a second one)
- a factory, registry, manager, builder or strategy for a single case
- a wrapper that only forwards a call, or indirection a reader must jump
  through to find what happens
- a class where a function would do
- configuration, options or hooks nobody asked for
- a design pattern chosen by name rather than by a need in front of you

## Designing a change

Before adding behavior (anything beyond a local fix):

1. Follow how the surrounding code is organized, and the project's
   AGENTS.md map if it has one.
2. Name what the change decides, what it talks to (database, network,
   files, UI) and what it coordinates.
3. Put each in the module that already owns it, or in a new module named
   after it, never in whichever file happens to be open.
4. If the existing design can't take the change cleanly, first refactor
   just the code the change touches, without changing behavior. Propose
   anything larger and ask before doing it.

Don't impose an architecture (layered, hexagonal, clean architecture)
unless the project already uses one or the user asks.

## Dependencies

Prefer an existing library over writing your own when it:

- solves the actual problem without a pile of glue code
- is maintained: a release or real commits in the last ~12 months, supports
  the project's language version, issues get answers
- is established: widely used, documented, with type information where the
  language has it
- has an enterprise-safe license: MIT, BSD, Apache-2.0, ISC, PSF or
  MPL-2.0. Ask first for LGPL. Never use GPL, AGPL, SSPL, BUSL/BSL, Commons
  Clause, custom or missing licenses.

Check license and activity on the package index or the repository, not from
memory. Prefer a library already in the dependency tree over a new one that
does the same. In your final report, give each new dependency one line:
name, why, license.

## Comments

Keep comments sparse and useful: when code is full of comments, readers and
reviewers skim past all of them and miss the few that matter. Comment only
what the code can't say for itself, in one short line of plain words. Say
why, never what, and never how you got here. Keep comments true when the
code changes. No section comments that designate areas.

```python
# Good: API returns naive datetimes; treat as UTC (#412).
# Bad:  loop over users / changed this to fix the bug
```

