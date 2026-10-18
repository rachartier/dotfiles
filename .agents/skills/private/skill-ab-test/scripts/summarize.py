"""Unblinds the judges' verdicts and writes summary.md for an iteration.

Usage: python3 summarize.py <workspace> [--iteration N]

Reads grading.json, timing.json and code_metrics.json from every run, and
blind/*/comparison.json with blind_key.json when the judges have finished.
"""

import argparse
import json
import statistics
from collections import defaultdict
from pathlib import Path

from layout import Spec, load_spec

CRITERIA = ("correctness", "scope", "design", "tests", "readability", "report")


def load_json(path: Path) -> dict:
    """Reads a JSON file, or returns an empty dict when it's missing."""
    return json.loads(path.read_text()) if path.exists() else {}


def mean(values: list[float]) -> float:
    """Returns the mean, or 0 for no values."""
    return statistics.mean(values) if values else 0.0


def run_table(spec: Spec, iteration: int) -> tuple[list[str], dict[str, dict[str, list[bool]]]]:
    """Builds the per-task table and collects each check's results per setup."""
    rows = [
        "| Task | Setup | Checks passed | Tokens | Time (s) | Src lines | Test lines | Files |",
        "|---|---|---|---|---|---|---|---|",
    ]
    by_check: dict[str, dict[str, list[bool]]] = defaultdict(lambda: defaultdict(list))
    totals: dict[str, list[tuple[int, int, int, float]]] = defaultdict(list)

    for ev in spec.evals:
        if not (spec.iteration_dir(iteration) / ev.slug).exists():
            continue
        for config in spec.configs:
            runs = [
                spec.iteration_dir(iteration) / ev.slug / config / f"run-{k}" for k in range(1, spec.runs + 1)
            ]
            gradings = [load_json(r / "grading.json") for r in runs]
            timings = [load_json(r / "timing.json") for r in runs]
            metrics = [load_json(r / "code_metrics.json") for r in runs]
            passed = sum(g.get("summary", {}).get("passed", 0) for g in gradings)
            total = sum(g.get("summary", {}).get("total", 0) for g in gradings)
            tokens = [t["total_tokens"] for t in timings if t]
            seconds = [t["total_duration_seconds"] for t in timings if t]
            for g in gradings:
                for e in g.get("expectations", []):
                    by_check[e["text"]][config].append(e["passed"])
            totals[config].extend(zip([passed], [total], [int(mean(tokens))], [mean(seconds)], strict=True))
            rows.append(
                f"| {ev.name} | {config} | {passed}/{total} | {mean(tokens):,.0f} | {mean(seconds):.0f} "
                f"| {mean([m.get('added_source_lines', 0) for m in metrics]):.0f} "
                f"| {mean([m.get('added_test_lines', 0) for m in metrics]):.0f} "
                f"| {mean([len(m.get('new_files', [])) for m in metrics]):.1f} |"
            )

    for config, items in totals.items():
        rows.append(
            f"| **all** | **{config}** | **{sum(i[0] for i in items)}/{sum(i[1] for i in items)}** "
            f"| {mean([i[2] for i in items]):,.0f} | {mean([i[3] for i in items]):.0f} | | | |"
        )
    return rows, by_check


def check_sections(by_check: dict[str, dict[str, list[bool]]], configs: list[str]) -> list[str]:
    """Splits checks into those that separate the setups and those that never do."""
    lines = ["## Checks that differ between setups", ""]
    same = []
    for text, results in by_check.items():
        rates = {c: f"{sum(results[c])}/{len(results[c])}" for c in configs}
        if len({sum(results[c]) / max(len(results[c]), 1) for c in configs}) > 1:
            lines.append(f"- {text}: " + ", ".join(f"{c} {r}" for c, r in rates.items()))
        else:
            same.append(f"- {text}: all setups {rates[configs[0]]}")
    lines += ["", "## Checks that don't discriminate (same rate in every setup)", "", *same]
    return lines


def blind_section(spec: Spec, iteration: int) -> list[str]:
    """Unblinds the judges' verdicts and averages their scores per setup."""
    blind = spec.iteration_dir(iteration) / "blind"
    key = load_json(blind / "blind_key.json")
    lines = [
        "## Blind judge",
        "",
        "| Pair | Winner | " + " | ".join(f"{c} score" for c in spec.configs) + " |",
        "|---|---|" + "---|" * len(spec.configs),
    ]
    wins: dict[str, int] = defaultdict(int)
    scores: dict[str, dict[str, list[float]]] = defaultdict(lambda: defaultdict(list))
    reasons = []

    for pair, mapping in sorted(key.items()):
        verdict = load_json(blind / pair / "comparison.json")
        if not verdict:
            lines.append(f"| {pair} | (no verdict yet) |" + " |" * len(spec.configs))
            continue

        winner = mapping.get(verdict["winner"], "TIE")
        wins[winner] += 1
        for label, config in mapping.items():
            for criterion in (*CRITERIA, "overall_score"):
                scores[config][criterion].append(verdict["scores"][label].get(criterion, 0))
        overall = " | ".join(
            str(verdict["scores"][label]["overall_score"])
            for label, _ in sorted(mapping.items(), key=lambda kv: list(spec.configs).index(kv[1]))
        )
        lines.append(f"| {pair} | {winner} | {overall} |")
        reasons.append(f"- **{pair}** ({winner}): {verdict['reasoning']}")

    if not wins:
        return []

    lines += [
        "",
        "Wins: " + ", ".join(f"{c} {wins[c]}" for c in (*spec.configs, "TIE") if wins[c]),
        "",
        "| Criterion | " + " | ".join(spec.configs) + " |",
        "|---|" + "---|" * len(spec.configs),
    ]
    for criterion in (*CRITERIA, "overall_score"):
        lines.append(
            f"| {criterion} | " + " | ".join(f"{mean(scores[c][criterion]):.1f}" for c in spec.configs) + " |"
        )
    return [*lines, "", "### Judges' reasoning", "", *reasons]


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--iteration", type=int, default=1)
    args = parser.parse_args()
    spec = load_spec(args.workspace)

    table, by_check = run_table(spec, args.iteration)
    parts = [
        f"# Skill A/B test: {' vs '.join(spec.configs)}",
        "",
        f"{len(spec.evals)} tasks x {spec.runs} runs per setup.",
        "",
        *table,
        "",
        *check_sections(by_check, list(spec.configs)),
        "",
        *blind_section(spec, args.iteration),
    ]
    out = spec.iteration_dir(args.iteration) / "summary.md"
    out.write_text("\n".join(parts) + "\n")
    print(out.read_text())


if __name__ == "__main__":
    main()
