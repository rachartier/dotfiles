---
name: remove-ai-slop
description: >-
  Strips AI writing tells from prose, markdown, code comments, docstrings and
  commit messages without changing their meaning or what the code does. Use when
  asked to de-slop or humanize text, to remove em dashes, or when text or
  comments read as AI-written.
---
# Remove AI slop

Rewrite text so it reads like a knowledgeable person typing plainly, and
comments so they read like a senior engineer wrote them. Only the wording
moves: the meaning, and what the code does, stay fixed.

The failure mode to avoid: rewriting so aggressively that facts drift, or
"fixing" the prose by swapping one set of AI tics for another.

## Workflow

1. Read the file. If it is long (over ~400 lines), work section by section,
   since single-pass rewrites of long documents quietly compress the back
   half.
2. Apply the edits below. In code, touch only comments, docstrings and
   messages, never the code itself.
3. Run the checks below on the result. Models emit these tells by habit, and
   the ones that survive a rewrite are the ones natural enough to slip past
   a reread; a search doesn't slip.
4. Report the changes you were least sure about. They are where you came
   closest to guessing at intent.

## Checks

```bash
# Dashes used as punctuation (numeric ranges like 2019–2024 are fine)
rg -n '[—–]' <file>

# Banned vocabulary (in code, only matches in comments and messages count)
rg -n -i -w 'delve|tapestry|realm|landscape|testament to|at its core|leverage|utilize|robust|seamless|comprehensive|curated|elevate|unlock|supercharge|game-changer|cutting-edge|best-in-class|furthermore|moreover|additionally|crucial|vital|essential|powerful|it.s worth noting|it.s important to note' <file>
```

In code, also check that the diff changes only comment, docstring and message
lines, then run the project's linter and tests.

## Em dashes

The output contains no em dashes (—) and no en dashes (–) used as
punctuation. Replace each one with:

- a comma, when the aside is short and grammatically parallel
- a period and a new sentence, when the dash joins two independent clauses
- a colon, when what follows explains what precedes
- parentheses, when the aside is a true aside
- nothing, when the aside was filler

A spaced hyphen ( - ) is the same tic in disguise. Leave alone en dashes in
numeric ranges (2019–2024), hyphens in compound words (well-known), and any
dash inside code, inline code or a direct quotation.

**Examples:**

Input: The migration took three weeks — longer than we expected.
Output: The migration took three weeks, longer than we expected.

Input: It's fast — and that matters when you're running it in CI.
Output: It's fast, which matters when you're running it in CI.

Input: We had two options — rewrite the parser, or patch around it.
Output: We had two options. Rewrite the parser, or patch around it.

## Sentence shapes to remove

- **Not-X-but-Y reveals.** "It's not just a linter, it's a formatter." Say
  what it is. The contrast is almost always manufactured.
- **Colon-then-payoff.** "The result? Faster builds." Merge into one sentence.
- **Interrupting asides** that exist for rhythm rather than information.
- **Fragments used for punch.** "No fluff. Just results."
- **Rhetorical questions** as openers or transitions.
- **Rule-of-three padding.** Three-item lists where the third item is a
  synonym of the second. Cut to two, or find a real third.
- **Restatement.** A sentence that says the previous one again in different
  words. Delete the weaker one.

## Vocabulary to remove

Register words: delve, tapestry, realm, landscape, testament to, navigate the
complexities, at its core, in the ever-evolving world of, in today's
fast-paced

Product-marketing words: leverage, utilize, robust, seamless, comprehensive,
curated, elevate, unlock, supercharge, game-changer, cutting-edge,
best-in-class

Filler transitions: furthermore, moreover, additionally, it's worth noting,
it's important to note, that said (when it introduces nothing contrastive)

Filler emphasis: crucial, vital, essential, key, powerful. Either cut them or
replace them with the specific reason the thing matters.

Assistant chatter: openers and sign-offs such as "Great question",
"Certainly!", "Here's a…", "I hope this helps", "Let me know if you have any
questions".

Substitutions that usually work: leverage → use, utilize → use, robust →
(name the property: fast, well-tested, handles malformed input),
comprehensive → complete or (cut), seamless → (cut, or say what doesn't
break).

## Code comments and docstrings

Keep comments that say why: a constraint, a workaround, an issue reference,
a decision a reader would otherwise undo. Remove or rewrite the rest:

- **Narration** of what the next line does: `# Loop through the users`,
  `# Return the result`.
- **Change history**: `# Fixed the bug`, `# Updated to use X`,
  `# New implementation`, `# As requested`. It belongs in the commit
  message.
- **Assistant voice**: I, we, let's, here we, now we, `Note:`, "This ensures
  that", "This function is responsible for", "Simply".
- **Placeholders that hedge**: `# In a real implementation…`,
  `# For production, consider…`, `# You may want to…`. Delete them; if one
  marks a real gap, list it in the report.
- **Section banners**: `# ===== Helpers =====`.
- **Docstrings that restate the signature**: `get_user` documented as "Gets
  the user", or `Args: user_id (int): The user ID.` Keep only what a caller
  can't read from the name and types, and drop the docstring on a trivial
  private helper.
- **Emoji and exclamation marks** in comments and messages:
  `✅ Successfully saved report!` → `saved report to {path}`. Log and error
  text is behavior: change it only after checking that no test or alert
  matches on it, and list each change in the report.

Leave alone: tool directives (`# noqa`, `# type: ignore`, `# pragma`,
`# fmt: off`), license headers, shebangs, and `TODO`s with an owner or
ticket.

In commit messages, the subject says what changed and the body says why.
Cut "This commit…", file-by-file lists and AI attribution lines.

## Structure to fix

- Bold lead-ins on every bullet, when the bullets are short enough not to
  need them
- Headers on sections short enough to be a single paragraph
- An intro that announces what the document covers, followed by a conclusion
  that restates it. Cut both, or the weaker one.
- Takeaway lines appended to sections that already made their point
- Emoji in headers or bullets, unless the document clearly uses them on
  purpose

## Tone to fix

- Hedging stacks: "may potentially in some cases" → pick one hedge
- Unsourced authority: "studies show", "experts agree", "research
  suggests". Strip the borrowed credibility but keep the claim, so "studies
  show teams save 30% of their time" becomes "teams save 30% of their
  time", and flag it in the report so the author can source or cut it.
  Deleting the claim removes information, which is not your call.
- Cheerleading about the subject matter
- Second-person coaching the author did not ask for: "You'll love how…"

## Preserve exactly

- Code, inline code, YAML frontmatter, tables, link targets and anchor text
- Heading hierarchy and document order
- Every technical claim, number, name, version and command
- Any voice or idiom that is clearly the author's own, including profanity,
  jokes and unusual sentence rhythm

Idiosyncrasy is not slop. When you can't tell whether something is the
author's voice or a model's tic, leave it and flag it.

## Judgment

Prefer short declarative sentences and concrete nouns.

When a sentence says nothing, delete it rather than rewriting it. A rewrite
of an empty sentence is still an empty sentence.

When you can't rewrite a sentence without guessing at facts, leave it and
say so in the report. A slightly stilted true sentence beats a smooth
invented one.

The word count should go down.

## Output

Edit the file in place; for pasted text, return the revised text. Then give
a short report: the changes you were least sure about, and anything you left
alone because fixing it would have required knowing something you don't.

If the user asks for a diff, produce a unified diff so they can reject
individual edits. Offer one for documents that need careful review, such as
published documentation.
