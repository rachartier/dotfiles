---
name: remove-ai-slop
description: >-
  Edit a markdown document to strip AI-generated writing tells (em dashes, "not
  X but Y" constructions, delve/leverage/robust vocabulary, filler transitions,
  restated conclusions) while preserving meaning exactly. Use this whenever the
  user asks to de-slop, de-AI, humanize, or clean up the wording of a document,
  or says text "sounds like ChatGPT," "sounds AI-written," "reads like a bot,"
  or asks to remove em dashes from prose. Also use when the user asks for an
  edit pass on a README, blog post, or doc where the complaint is tone or
  wording rather than facts. Prefer this over an ad-hoc rewrite, since an ad-hoc
  rewrite tends to introduce the same tells it is meant to remove.
---
# Remove AI slop

Rewrite a document so it reads like a knowledgeable person typing plainly, without
changing what it says.

The failure mode to avoid: rewriting so aggressively that facts drift, or "fixing"
the prose by swapping one set of AI tics for another. The author's meaning is fixed.
Only the wording moves.

## Workflow

1. Read the file. If it is long (over ~400 lines), work section by section rather
   than in one pass, since single-pass rewrites of long documents quietly compress
   the back half.
2. Apply the edits below.
3. Verify the result with a dedicated pass. Do not trust the rewrite to have
   removed what you intended. Reread the output looking only for leftover em
   dashes, then reread it looking only for the banned vocabulary. Two narrow passes
   catch more than one broad one, because a general reread slides over familiar
   text. If you have a search tool, grep the output for `—` and for the vocabulary
   list rather than eyeballing it.
4. Report the changes you were least sure about. These are the ones the author
   needs to check, because they are where you were closest to guessing at intent.

## Hard rule: no em dashes

The output must contain zero em dashes (—) and zero en dashes (–) used as
punctuation. Replace each one with:

- a comma, when the aside is short and grammatically parallel
- a period and a new sentence, when the dash joins two independent clauses
- a colon, when what follows genuinely explains what precedes
- parentheses, when the aside is a true aside
- nothing, when the aside was filler

Do not substitute a spaced hyphen ( - ). That is the same tic in disguise.

Leave alone: en dashes inside numeric ranges (2019–2024), hyphens inside compound
words (well-known), and any dash inside a code block, inline code, or direct
quotation.

This rule needs its own verification pass because the em dash is a single token
that models emit by habit. Intending to remove them is not the same as removing
them, and the ones that survive a rewrite are exactly the ones that read naturally
enough to slip past a general reread.

**Examples:**

Input: The migration took three weeks — longer than we expected.
Output: The migration took three weeks, longer than we expected.

Input: It's fast — and that matters when you're running it in CI.
Output: It's fast, which matters when you're running it in CI.

Input: We had two options — rewrite the parser, or patch around it.
Output: We had two options. Rewrite the parser, or patch around it.

## Sentence shapes to remove

- **Not-X-but-Y reveals.** "It's not just a linter, it's a formatter." Say what it
  is. The contrast is almost always manufactured.
- **Colon-then-payoff.** "The result? Faster builds." Merge into one sentence.
- **Interrupting asides** that exist for rhythm rather than information.
- **Fragments used for punch.** "No fluff. Just results."
- **Rhetorical questions** as openers or transitions.
- **Rule-of-three padding.** Three-item lists where the third item is a synonym of
  the second. Cut to two, or find a real third.
- **Restatement.** A sentence that says the previous sentence again in different
  words. Delete the weaker one.

## Vocabulary to remove

Register words: delve, tapestry, realm, landscape, testament to, navigate the
complexities, at its core, in the ever-evolving world of, in today's fast-paced

Product-marketing words: leverage, utilize, robust, seamless, comprehensive,
curated, elevate, unlock, supercharge, game-changer, cutting-edge, best-in-class

Filler transitions: furthermore, moreover, additionally, it's worth noting, it's
important to note, that said (when it introduces nothing contrastive)

Filler emphasis: crucial, vital, essential, key, powerful. These are usually
adjectives doing no work. Either cut them or replace them with the specific reason
the thing matters.

Substitutions that usually work: leverage → use, utilize → use, robust →
(name the actual property: fast, well-tested, handles malformed input),
comprehensive → complete or (cut), seamless → (cut, or say what does not break).

## Structure to fix

- Bold lead-ins on every bullet, when the bullets are short enough not to need them
- Headers on sections short enough to be a single paragraph
- An intro that announces what the document covers, followed by a conclusion that
  restates what it just covered. Cut both, or cut the weaker one.
- Takeaway lines appended to sections that already made their point
- Emoji in headers or bullets, unless the surrounding document clearly uses them on
  purpose

## Tone to fix

- Hedging stacks: "may potentially in some cases" → pick one hedge
- Unsourced authority: "studies show," "experts agree," "research suggests." Strip
  the borrowed credibility but keep the claim, so "studies show teams save 30% of
  their time" becomes "teams save 30% of their time." Deleting the claim outright
  removes information, which is not your call. Flag it in the notes instead so the
  author can source it or cut it.
- Cheerleading about the subject matter
- Second-person coaching the author did not ask for: "You'll love how..."

## Preserve exactly

- Code blocks, inline code, YAML frontmatter, tables, link targets and anchor text
- Heading hierarchy and document order
- Every technical claim, number, name, version, and command
- Any voice or idiom that is clearly the author's own, including profanity, jokes,
  and unusual sentence rhythm

Idiosyncrasy is not slop. A writer with a distinctive habit is the opposite of the
thing being removed. When you cannot tell whether something is the author's voice
or a model's tic, leave it and flag it.

## Judgment

Prefer short declarative sentences and concrete nouns.

When a sentence says nothing, delete it rather than rewriting it. A rewrite of an
empty sentence is still an empty sentence.

When you cannot rewrite a sentence without guessing at facts, leave it alone and
say so in the notes. A slightly stilted true sentence beats a smooth invented one.

Do not lengthen the document. The word count should go down.

## Output

Return the full revised markdown, then a `---` separator, then a short list of the
changes you were least sure about and anything you left alone because fixing it
would have required knowing something you do not know.

If the user asked for a diff instead, produce a unified diff so they can reject
individual edits. Offer this if the document is one they will need to review
carefully, such as published documentation.
