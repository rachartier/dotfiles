---
name: python-comments
description: >-
  Write, audit, and strip Python comments and Google-style docstrings. Use when
  adding or reviewing comments and docstrings, when a diff has comment noise,
  and when cleaning verbose, stale, or narrating comments out of existing code.
---
# Python comments and docstrings

Where `copilot-instructions.md` or `AGENTS.md` states comment rules, they win.
This skill adds the refactoring procedure.

## Never touch

Directives are not comments. Leave byte-exact:

- `# type: ignore`, `# noqa`, `# pragma: no cover`, `# pylint: disable`,
  `# ruff: noqa`, `# fmt: off` / `# fmt: on`, `# isort: skip`, `# mypy:`
- Shebang, encoding declaration, SPDX identifier, license or copyright header
- `>>>` doctests inside docstrings — they execute
- Sphinx/MkDocs directives the docs build reads
- `TODO(owner): <action>` pointing at a tracked issue

## Writing new

Default: none. A comment needs all three:

1. Not already clear from names, types, and structure.
2. Its absence could lead a reader to make a wrong change.
3. Describes the code as it is now, not how it got there.

Docstrings on public modules, classes, functions. Google style: one imperative
summary line ending in a period, blank line, then `Args:` (meaning, not type),
`Returns:` or `Yields:`, `Raises:`. No types, no name echo, no filler openers.
Skip private helpers, one-liners, functions under ~3 lines with clear names, and
`__init__` that only assigns arguments.

## Refactoring existing

Classify every comment, then act:

| Verdict | Applies to | Action |
|---|---|---|
| Delete | Restates code, narration, section banner, commented-out code, changelog or bug story, "added by X" / "fixed in v2", advice contradicted by the code | Remove |
| Compress | Multi-line rationale, wall-of-text warning | One line, plus an issue or spec link |
| Keep | External constraint, invariant, edge case, directive | Leave, shorten only if safe |
| Promote | Comment says what a name should have said | Rename or extract a function, then delete the comment |

Docstring rewrite, in order:

1. Strip types from `Args:` entries.
2. Delete `Note:` / `History:` / `Changelog:` / `Author:` / `Version:` sections.
3. Delete example blocks that only replay the signature; keep doctests.
4. Collapse to summary plus at most one paragraph that adds real information.
5. If it only echoes the name on a private or trivial function, delete it.

Rules for the pass:

- Comment-only diffs. Never change runtime behavior in the same commit.
- One file at a time. Keep it reviewable.
- Code is the truth. A comment that contradicts the code gets deleted or
  corrected, never left alongside.
- When unsure whether a comment holds knowledge absent from the code — a magic
  constant, a protocol quirk, a hardware limit — keep it and shorten it. Losing
  knowledge costs more than one surviving line.
- Add no comment explaining the cleanup, and no summary of it in the code.

## Strip AI slop

Applies to both new and existing comments and docstrings. In prose only — never
alter string literals, test fixtures, or data.

- **Em dashes and en dashes.** Rewrite the sentence, or use a plain hyphen,
  comma, or period. Same for `…`, curly quotes, and `→`.
- **Hedge and filler openers.** "It's worth noting that", "Note that",
  "Importantly", "Essentially", "Basically", "In practice", "Simply",
  "As mentioned above", "In summary".
- **Marketing adjectives.** seamless, robust, powerful, elegant, comprehensive,
  efficient, flexible, intuitive, best-in-class. Say the property or say nothing.
- **Padding verbs.** leverage → use. utilize → use. facilitate → let. ensure
  that → make. delve into → cover.
- **The "not just X, but Y" construction**, rhetorical triads, and rhetorical
  questions.
- **Emoji, checkmarks, and decorative separators** (`# ====`, `# ----`).
- **Restating the obvious with emphasis**: bold, ALL CAPS, or `!!!` in a comment
  is a sign the comment is arguing rather than informing. Cut or state it plainly.

A comment that survives this pass is a plain declarative sentence, ASCII, one
line where possible.

## Scope

Only the files named or already being modified. No drive-by cleanup of untouched
code.

## Before finishing

- No comment restates the line next to it.
- No docstring states a type or repeats the function name.
- Every surviving comment answers "why".
- All directives byte-identical to before.
- No em dash, curly quote, or emoji in any comment or docstring.
- Doctests still pass if any docstring was touched.

```python
# Good
# Upstream returns naive datetimes; see #412.

# Bad
# Parse the timestamp. We used UTC before, which caused duplicate rows in
# prod, so now we localize explicitly. -- jdoe, 2024
```
