"""Records a finished run's cost and, when the agent couldn't save it, its report.

Usage:
    python3 save_run.py <run_dir> --tokens N --ms N [--model NAME] [--report FILE|-]

The token count and duration come from the agent's completion notice; they
are not stored anywhere else, so save them as each run finishes.
"""

import argparse
import json
import sys
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("run_dir", type=Path)
    parser.add_argument("--tokens", type=int, required=True)
    parser.add_argument("--ms", type=int, required=True)
    parser.add_argument("--model", help="model and effort the agent ran on, e.g. claude-opus-5-5/medium")
    parser.add_argument("--report", help="file holding the agent's final message, or - for stdin")
    args = parser.parse_args()

    timing = {
        "total_tokens": args.tokens,
        "duration_ms": args.ms,
        "total_duration_seconds": round(args.ms / 1000, 1),
    }
    if args.model:
        timing["model"] = args.model
    (args.run_dir / "timing.json").write_text(json.dumps(timing, indent=2))

    report = args.run_dir / "outputs" / "report.md"
    if args.report:
        text = sys.stdin.read() if args.report == "-" else Path(args.report).read_text()
        report.parent.mkdir(exist_ok=True)
        report.write_text(text)

    print(f"{args.run_dir}: timing saved, report {'present' if report.exists() else 'MISSING'}")


if __name__ == "__main__":
    main()
