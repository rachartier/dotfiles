---
name: skill-ab-test
description: A/B test coding skills to see whether a change made a difference - old vs new version, or a skill with vs without a companion skill - using isolated agent runs on realistic tasks, scripted checks against the starting code, and blind judging. Use when asked to test, compare, benchmark or evaluate skill versions, or whether a skill change helped.
---
# Skill A/B test

Answer "did this skill change make the agent's code better?" with evidence: the
same realistic tasks run by fresh agents under each setup, graded by scripts
and by a blind judge, and reported with the trade-offs.

The scripts in `scripts/` run with plain `python3` (3.12+) and need `uv`, `ruff`
and `uvx ty` for Python grading. `references/example/` is a complete worked
spec from a real test (python-style old vs new + code-design).

## 1. Pin down the comparison before spending anything

A test is 2 setups x 3-5 tasks x 2 runs = 12-20 agent runs, plus one judge per
pair, so settle these first, in one round of questions:

- **The exact versions.** Get the old version as a file (attached, or from git).
  Skill files usually carry no version number, and rebuilding one from memory or
  past chats tests the wrong thing.
- **The setups.** Each setup is a list of skill files: e.g. "old python-style
  alone" vs "new python-style + code-design". A no-skill baseline is a third
  setup; the blind judge only pairs two, so pick the two that matter.
- **Runs per setup.** 2 is the useful minimum (one run can mislead); say what it
  costs.

Without a way to spawn isolated agents, say so: running the tasks yourself with
both versions in context is not a fair test.

## 2. Build the workspace

```
<name>-workspace/
  evals.json            setups, tasks, hidden tests, command checks
  skills/<setup>/...    frozen copies of every skill file under test
  fixtures/<name>/      starting project per task (absent = empty folder)
  hidden/               behaviour tests the agents never see
  iteration-1/          created by setup_runs.py; blind/ and summary.md go here
```

Copy the skills into `skills/` (never point agents at the installed copies,
which change and may be the other version). `evals.json` format: see
`references/example/evals.json`.

### Design tasks that can tell the setups apart

Read both versions and list the rules that differ. Each task should give those
rules a chance to matter, phrased the way the user would really ask:

- **New code with I/O** (a small CLI calling an API): wiring, dependency choice,
  tooling, types, docstrings.
- **A change to messy existing code**: a fixture with the smells the rules
  target (a `utils.py`, globals read at import, `mock.patch` tests, old typing).
  Tests scope discipline and "change only what you touch".
- **A temptation to over-build** (add retry to one call): stdlib vs library,
  class vs function.
- **A tiny pure function**: checks the skill doesn't add ceremony.

Make every fixture pass its own tests before using it. Where the answer is
checkable, add a hidden test: write it against behaviour, not names (discover
the single public function, try optional kwargs, then fall back), and pick
cases a naive solution fails (e.g. timestamps in different offsets that string
comparison orders wrongly). Add `checks` (shell commands run in the project,
`$REPORT` = the agent's report, optional `max_seconds`) for anything else.

Show the user the task list and what each one tests before running.

## 3. Run every agent at once

```bash
python3 scripts/setup_runs.py <workspace>
```

It copies a fresh fixture into each `iteration-1/eval-<id>-<name>/<setup>/run-<k>/project`
and writes that run's `prompt.txt` from `references/run_prompt.md`. Then spawn
one background subagent per run, all in the same turn, each given exactly its
`prompt.txt`. The prompt confines the agent to its listed skill files: it must
not use the Skill tool or open installed skills, or the setups blur.

Keep `agent_map.json` (agent id -> run folder) as you spawn. As each agent
finishes, record its cost at once; the completion notice is the only place it
appears:

```bash
python3 scripts/save_run.py <run_dir> --tokens <total_tokens> --ms <duration_ms> --model <model>/<effort>
```

Subagents are sometimes blocked from writing `outputs/report.md`. Their final
message is the report: save it word for word with `--report -` (stdin). Don't
open agent transcript files; they're huge.

## 4. Grade with scripts, then calibrate the checks

```bash
python3 scripts/grade_python.py <workspace>
```

For Python it checks: tests pass; ruff adds no findings beyond the fixture's
own; ty clean; touched functions fully annotated; no `List/Dict/Optional`; docstrings
present and descriptive; no bare `# type: ignore`; no patching of module paths
in new tests; no catch-all module names; vertical spacing; plus the eval's
hidden tests and command checks. Only code the run wrote or changed is judged
(AST diff against the fixture). Edit the checks to match the rules of the skills
under test; for another language, write `grade_<lang>.py` with the same output
files.

Then read every failure before trusting the numbers. False positives seen in
practice, already handled: pre-existing lint in the fixture, a class flagged
because one method changed, an import that was only reordered, a `TypedDict`
counted as "a class". Fix the check (not the run) and regrade everything.

## 5. Blind judging

```bash
python3 scripts/make_blind.py <workspace>
```

It pairs run k of each setup into `iteration-1/blind/<eval>-pair-<k>/A|B` in random order,
adds `ORIGINAL` (the fixture), strips venvs and run paths from reports, writes
`JUDGE_PROMPT.txt` and keeps the answer key in `iteration-1/blind/blind_key.json`. It must print
"no leaks found"; a report that names the setup's folder unblinds the judge.

Spawn one judge per pair, all at once: "Read <pair>/JUDGE_PROMPT.txt and follow
it exactly." Each writes `comparison.json` with 1-5 scores on correctness, scope,
design, tests, readability and report, plus a 1-10 overall and a winner.

## 6. Summarize

```bash
python3 scripts/summarize.py <workspace>
```

Writes `iteration-1/summary.md`: per-task checks, tokens, time and code size;
which checks separate the setups and which never do; unblinded wins, mean
scores per criterion and every judge's reasoning.

If the skill-creator skill is available, also build its review page: run its
`scripts/aggregate_benchmark.py <workspace>/iteration-1 --skill-name <name>`,
fix `runs_per_configuration` in `benchmark.json`, put your findings in its
`notes` list, then `eval-viewer/generate_review.py <workspace>/iteration-1
--benchmark <workspace>/iteration-1/benchmark.json --static <file>.html`
and send the file. (Don't store timing in `grading.json`, or the aggregator
skips the token counts in `timing.json`.)

## 7. Report

Lead with the verdict and a small table: blind wins, mean judge score, checks
passed, tokens and time per run. Then:

- **Where the change helped**, with the evidence (which checks, which pairs).
- **Where it backfired.** Read the judges' reasoning for every pair the new
  setup lost, and look at the per-criterion scores (a lower `scope` score is the
  usual sign a rule pushed agents into unrequested changes).
- **A concrete skill edit** for each backfire, in one line, ideally taken from
  the run that got it right.
- **Caveats**: sample size, judges are the same model family as the coders,
  rules no script measured.

Offer to apply the edit and re-run only the tasks it affects as a new iteration:
update the new setup's files in `skills/`, then
`setup_runs.py <workspace> --iteration 2 --only <task>,<task>` and the same
steps with `--iteration 2`.
