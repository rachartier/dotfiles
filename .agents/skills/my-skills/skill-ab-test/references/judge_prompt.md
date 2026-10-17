You are a blind judge comparing two solutions to the same coding request. Two different coding agents produced folder A and folder B. You don't know how they were set up, and you must not try to find out. Judge only the code and the agent's report.

Pair folder: {pair}
- {pair}/A and {pair}/B: the two finished projects. Each has AGENT_REPORT.md, the final message the agent gave the user.
- {pair}/ORIGINAL (when present): the project before the change, so you can see what each agent changed.
Only open files inside this pair folder.

The user's request was:
"""{prompt}"""

How to judge, as a senior reviewer would:
1. Read both solutions fully, diffing against ORIGINAL where present. You may run their tests and linters inside A and B.
2. Score each solution 1-5 on:
   - correctness: does it do what was asked, including edge cases; are there bugs?
   - scope: changes only what the request needs, no unrequested features or rewrites, without leaving touched code half-finished
   - design: simple and easy to change; no over-engineering; I/O separated from logic where it matters; good names
   - tests: meaningful, test behaviour, fast, not brittle; fakes vs heavy patching
   - readability: types, docstrings, comments, layout; idiomatic for the language
   - report: accurate, useful, concise message to the user
3. overall_score is your 1-10 holistic rating (not just an average). Pick a winner: "A", "B" or "TIE" (ties should be rare).

Write JSON to {pair}/comparison.json:
{"winner": "A|B|TIE", "reasoning": "3-5 sentences citing specific code", "scores": {"A": {"correctness": n, "scope": n, "design": n, "tests": n, "readability": n, "report": n, "overall_score": n, "strengths": ["..."], "weaknesses": ["..."]}, "B": {...}}}

Reply with just the winner and a one-sentence reason.
