"""Creates one fresh project copy and one agent prompt per run.

Usage: python3 setup_runs.py <workspace> [--iteration N]
"""

import argparse
import json
import shutil
from pathlib import Path

from layout import SKILL_ROOT, Eval, Spec, load_spec

TEMPLATE = SKILL_ROOT / "references" / "run_prompt.md"
IGNORE = shutil.ignore_patterns(".venv", "__pycache__", ".pytest_cache", ".ruff_cache", "uv.lock")


def write_prompt(spec: Spec, ev: Eval, config: str, run_dir: Path) -> Path:
    """Fills the run prompt template for one run and saves it next to the run."""
    skills = "\n".join(f"- {spec.workspace / path}" for path in spec.configs[config])
    prompt = (
        TEMPLATE.read_text()
        .replace("{skills}", skills)
        .replace("{workspace}", str(spec.workspace))
        .replace("{project}", str(run_dir / "project"))
        .replace("{report}", str(run_dir / "outputs" / "report.md"))
        .replace("{prompt}", ev.prompt)
    )
    path = run_dir / "prompt.txt"
    path.write_text(prompt)
    return path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--iteration", type=int, default=1)
    parser.add_argument("--only", default="", help="comma-separated eval names to set up (default: all)")
    args = parser.parse_args()
    spec = load_spec(args.workspace)

    missing = [p for paths in spec.configs.values() for p in paths if not (spec.workspace / p).exists()]
    if missing:
        raise SystemExit(f"skill files not found: {missing}")

    wanted = set(filter(None, args.only.split(",")))
    for ev, config, run, run_dir in spec.runs_of(args.iteration):
        if wanted and ev.name not in wanted:
            continue
        project = run_dir / "project"
        if project.exists():
            shutil.rmtree(project)

        fixture = spec.fixture_dir(ev)
        if fixture.is_dir():
            shutil.copytree(fixture, project, ignore=IGNORE)
        else:
            project.mkdir(parents=True)

        (run_dir / "outputs").mkdir(exist_ok=True)
        meta = {"eval_id": ev.id, "eval_name": ev.name, "fixture": ev.fixture, "prompt": ev.prompt}
        (run_dir.parent.parent / "eval_metadata.json").write_text(json.dumps(meta, indent=2))
        prompt_file = write_prompt(spec, ev, config, run_dir)
        print(f"{ev.slug}/{config}/run-{run}\t{prompt_file}")


if __name__ == "__main__":
    main()
