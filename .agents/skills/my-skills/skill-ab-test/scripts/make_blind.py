"""Copies each pair of runs into neutral A/B folders for a blind judge.

Usage: python3 make_blind.py <workspace> [--iteration N] [--seed N]

Pairs run k of the first setup with run k of the second, in random order.
Writes iteration-N/blind/<eval>-pair-<k>/{A,B,ORIGINAL,JUDGE_PROMPT.txt} and
the answer key to iteration-N/blind/blind_key.json, which judges must never see.
"""

import argparse
import json
import random
import re
import shutil
from pathlib import Path

from layout import SKILL_ROOT, load_spec

TEMPLATE = SKILL_ROOT / "references" / "judge_prompt.md"
IGNORE = shutil.ignore_patterns(
    ".venv", "__pycache__", ".pytest_cache", ".ruff_cache", ".mypy_cache", "uv.lock"
)


def scrub(report: str, workspace: Path) -> str:
    """Removes run paths and report-file mentions, which reveal the setup's name."""
    report = re.sub(rf"{re.escape(str(workspace))}/\S*?/run-\d+/(project/?|outputs/report\.md)?", "", report)
    report = re.sub(rf"{re.escape(str(workspace))}\S*", "", report)
    report = re.sub(r"/[^\s`)]*/run-\d+/(project/?)?", "", report)
    return re.sub(r".*report\.md.*\n?", "", report)


def leaks(folder: Path, workspace: Path, configs: list[str]) -> list[Path]:
    """Lists files in a blind folder that still mention the workspace or a setup folder."""
    pattern = re.compile(
        "|".join([re.escape(str(workspace)), "SKILL.md", *(rf"/{re.escape(c)}/" for c in configs)])
    )
    return [
        p
        for p in folder.rglob("*")
        if p.is_file()
        and p.name not in {"JUDGE_PROMPT.txt", "blind_key.json"}
        and pattern.search(p.read_text(errors="ignore"))
    ]


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--iteration", type=int, default=1)
    parser.add_argument("--seed", type=int, default=17)
    args = parser.parse_args()
    spec = load_spec(args.workspace)
    configs = list(spec.configs)
    if len(configs) != 2:
        raise SystemExit(f"blind pairs need exactly two setups, got {configs}")

    rng = random.Random(args.seed)
    key: dict[str, dict[str, str]] = {}
    blind = spec.iteration_dir(args.iteration) / "blind"
    for ev in spec.evals:
        if not (spec.iteration_dir(args.iteration) / ev.slug).exists():
            continue
        for run in range(1, spec.runs + 1):
            pair = blind / f"{ev.slug}-pair-{run}"
            if pair.exists():
                shutil.rmtree(pair)

            order = configs[:]
            rng.shuffle(order)
            key[pair.name] = dict(zip("AB", order, strict=True))
            for label, config in key[pair.name].items():
                run_dir = spec.iteration_dir(args.iteration) / ev.slug / config / f"run-{run}"
                shutil.copytree(run_dir / "project", pair / label, ignore=IGNORE)
                report = run_dir / "outputs" / "report.md"
                text = report.read_text() if report.exists() else "(no report)"
                (pair / label / "AGENT_REPORT.md").write_text(scrub(text, spec.workspace))

            fixture = spec.fixture_dir(ev)
            if fixture.is_dir() and any(fixture.iterdir()):
                shutil.copytree(fixture, pair / "ORIGINAL", ignore=IGNORE)
            prompt = TEMPLATE.read_text().replace("{pair}", str(pair)).replace("{prompt}", ev.prompt)
            (pair / "JUDGE_PROMPT.txt").write_text(prompt)

    (blind / "blind_key.json").write_text(json.dumps(key, indent=2))
    found = leaks(blind, spec.workspace, configs)
    for path in found:
        print(f"LEAK, fix before judging: {path}")
    print(f"{len(key)} pairs in {blind}" + ("" if found else ", no leaks found"))


if __name__ == "__main__":
    main()
