"""Grades every Python run of an iteration with scripted checks.

Usage: python3 grade_python.py <workspace> [--iteration N] [--only TEXT]

For each finished run (one with outputs/report.md) it writes grading.json
(viewer format: text/passed/evidence), code_metrics.json, and copies the
touched files flat into outputs/ so the review page can show them.
"""

import argparse
import ast
import json
import os
import re
import shutil
import subprocess
import time
from dataclasses import asdict, dataclass
from pathlib import Path

from code_diff import Changes, find_changes, is_test
from layout import Eval, Spec, load_spec

LEGACY_TYPING = re.compile(
    r"\b(List|Dict|Optional|Union|Tuple|Set)\[|from typing import .*\b(List|Dict|Optional|Union)\b"
)
CATCH_ALL_NAMES = {"utils", "helpers", "common", "manager", "misc"}
PATCHING = re.compile(r"mock\.patch|\bpatch\(|monkeypatch\.setattr")
ARGS_WITH_TYPES = re.compile(r"^\s+\*{0,2}\w+ \([^)]*\):", re.MULTILINE)
BARE_IGNORE = re.compile(r"#\s*type:\s*ignore(?!\[)")


@dataclass(frozen=True)
class Check:
    """One graded expectation, in the review page's format."""

    text: str
    passed: bool
    evidence: str


def run(
    cmd: list[str] | str, cwd: Path, timeout: int = 240, env: dict[str, str] | None = None
) -> tuple[int, str, float]:
    """Runs a command and returns its exit code, combined output and duration."""
    start = time.monotonic()
    try:
        done = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=timeout,
            shell=isinstance(cmd, str),
            env={**os.environ, **(env or {})},
        )
    except subprocess.TimeoutExpired:
        return 124, "timed out", float(timeout)
    return done.returncode, (done.stdout + done.stderr).strip(), time.monotonic() - start


def last_line(text: str) -> str:
    """Returns the last non-empty line, for evidence."""
    lines = [ln for ln in text.splitlines() if ln.strip()]
    return lines[-1][:200] if lines else ""


def ruff_findings(root: Path) -> list[str]:
    """Returns `file:code` for each ruff finding, using the project's config."""
    _, out, _ = run(
        ["ruff", "check", "--no-cache", "--exclude", ".venv", "--output-format", "json", "."],
        root,
        env={"XDG_CONFIG_HOME": "/nonexistent"},
    )
    try:
        items = json.loads(out)
    except json.JSONDecodeError:
        return [out[:200]]
    return sorted(f"{Path(i['filename']).resolve().relative_to(root.resolve())}:{i['code']}" for i in items)


def tooling_checks(project: Path, fixture: Path) -> list[Check]:
    """Runs the tests, ruff (against the fixture's own findings) and ty."""
    code, out, _ = run(["uv", "run", "--quiet", "pytest", "-q", "-p", "no:cacheprovider"], project)
    checks = [Check("The project's tests pass (uv run pytest)", code == 0, last_line(out))]

    before = ruff_findings(fixture) if fixture.is_dir() and any(fixture.rglob("*.py")) else []
    added = ruff_findings(project)
    for item in before:
        if item in added:
            added.remove(item)
    checks.append(
        Check(
            "ruff check (project config) adds no new findings",
            not added,
            f"new: {added[:5] or 'none'}; already in the starting code: {len(before)}",
        )
    )

    code, out, _ = run(["uvx", "ty", "check", "--exclude", ".venv"], project)
    summary = next(
        (ln for ln in reversed(out.splitlines()) if "diagnostic" in ln or "All checks" in ln), last_line(out)
    )
    checks.append(Check("ty check is clean", code == 0, summary[:200]))
    return checks


def _decorators(node: ast.AST) -> set[str]:
    names = set()
    for d in getattr(node, "decorator_list", []):
        target = d.func if isinstance(d, ast.Call) else d
        names.add(ast.unparse(target).split(".")[-1])
    return names


def check_annotations(ch: Changes) -> Check:
    """Every touched function outside `test_` functions annotates params and return."""
    missing = []
    for f in ch.functions:
        if is_test(f.file):
            continue

        args = f.node.args
        params = [*args.posonlyargs, *args.args, *args.kwonlyargs]
        if params and params[0].arg in {"self", "cls"}:
            params = params[1:]
        params += [a for a in (args.vararg, args.kwarg) if a]
        bad = [p.arg for p in params if p.annotation is None]
        if bad or (f.node.returns is None and f.node.name != "__init__"):
            missing.append(f"{f.file}:{f.qualname}" + (f" params {bad}" if bad else " return"))

    return Check(
        "Every function written or changed (outside test files) annotates all parameters and its return",
        not missing,
        "; ".join(missing[:6]) or f"{len(ch.functions)} functions checked",
    )


def check_added_lines(ch: Changes, text: str, pattern: re.Pattern[str], *, tests_only: bool = False) -> Check:
    """Passes when no added line matches `pattern`."""
    hits = [
        f"{rel}: {ln.strip()[:70]}"
        for rel, lines in ch.added_lines.items()
        if not tests_only or is_test(rel)
        for ln in lines
        if pattern.search(ln)
    ]
    return Check(text, not hits, "; ".join(hits[:4]) or "none in added lines")


def check_docstrings(ch: Changes, project: Path) -> Check:
    """New modules, new public classes and touched public functions have docstrings."""
    missing = [
        f"{rel}: module"
        for rel in ch.new_files
        if not is_test(rel)
        and rel.name != "__init__.py"
        and ast.get_docstring(ast.parse((project / rel).read_text())) is None
    ]
    missing += [
        f"{c.file}:{c.node.name}"
        for c in ch.classes
        if not is_test(c.file) and not c.node.name.startswith("_") and ast.get_docstring(c.node) is None
    ]
    missing += [
        f"{f.file}:{f.qualname}"
        for f in ch.functions
        if not is_test(f.file)
        and not any(part.startswith("_") for part in f.qualname.split("."))
        and "override" not in _decorators(f.node)
        and ast.get_docstring(f.node) is None
    ]
    return Check(
        "Modules, public classes and public functions written or changed have docstrings",
        not missing,
        "; ".join(missing[:6]) or "all present",
    )


def check_docstring_style(ch: Changes) -> Check:
    """Function summaries are descriptive ("Fetches…") with no types in Args."""
    bad = []
    for f in ch.functions:
        doc = ast.get_docstring(f.node)
        if not doc or is_test(f.file) or "property" in _decorators(f.node):
            continue

        first = doc.split()[0].rstrip(".,:")
        if not first.endswith("s"):
            bad.append(f"{f.file}:{f.qualname} '{doc.splitlines()[0][:50]}'")
        if ARGS_WITH_TYPES.search(doc):
            bad.append(f"{f.file}:{f.qualname} types in Args")

    return Check(
        "Function docstrings use descriptive summaries ('Fetches…') with no types in Args",
        not bad,
        "; ".join(bad[:5]) or "all descriptive",
    )


def check_spacing(ch: Changes, project: Path) -> Check:
    """No blank line right after def/docstring and no double blank lines in functions."""
    bad = []
    for f in ch.functions:
        lines = (project / f.file).read_text().splitlines()
        has_doc = ast.get_docstring(f.node) is not None
        first_code = (
            f.node.body[1] if has_doc and len(f.node.body) > 1 else (None if has_doc else f.node.body[0])
        )
        header_end = f.node.body[0].end_lineno if has_doc else f.node.body[0].lineno - 1
        if first_code is not None and header_end is not None:
            between = [
                ln
                for ln in lines[header_end : first_code.lineno - 1]
                if not ln.strip().startswith(("@", "#"))
            ]
            if between and all(not ln.strip() for ln in between):
                bad.append(f"{f.file}:{f.qualname} blank line after def/docstring")

        segment = lines[f.node.lineno - 1 : f.node.end_lineno]
        if any(not a.strip() and not b.strip() for a, b in zip(segment, segment[1:], strict=False)):
            bad.append(f"{f.file}:{f.qualname} double blank line")

    return Check(
        "Vertical spacing: no blank line right after def/docstring, no double blank lines in functions",
        not bad,
        "; ".join(bad[:5]) or f"{len(ch.functions)} functions checked",
    )


def check_module_names(ch: Changes) -> Check:
    """No new catch-all module."""
    bad = [str(rel) for rel in ch.new_files if rel.stem in CATCH_ALL_NAMES]
    return Check(
        "No new catch-all module (utils/helpers/common/manager/misc)",
        not bad,
        ", ".join(bad) or f"new files: {', '.join(map(str, ch.new_files)) or 'none'}",
    )


def hidden_test_checks(spec: Spec, ev: Eval, project: Path) -> list[Check]:
    """Copies each hidden test in, runs it alone, then removes it."""
    checks = []
    for hidden in ev.hidden_tests:
        source = spec.workspace / hidden.file
        target = project / hidden.dest / source.name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(source, target)
        try:
            code, out, _ = run(
                [
                    "uv",
                    "run",
                    "--quiet",
                    "--with",
                    "pytest",
                    "pytest",
                    "-q",
                    "-p",
                    "no:cacheprovider",
                    str(target.relative_to(project)),
                ],
                project,
            )
        finally:
            target.unlink()
        checks.append(Check(hidden.text, code == 0, last_line(out)))
    return checks


def command_checks(ev: Eval, project: Path, report: Path) -> list[Check]:
    """Runs the eval's shell checks; $REPORT points at the agent's report."""
    checks = []
    for check in ev.checks:
        code, out, seconds = run(check.cmd, project, env={"REPORT": str(report)})
        passed = code == 0 and (check.max_seconds is None or seconds <= check.max_seconds)
        checks.append(Check(check.text, passed, f"exit {code}, {seconds:.1f}s; {last_line(out)}"))
    return checks


def code_metrics(ch: Changes) -> dict[str, object]:
    """Counts added source, test and comment lines."""
    src = tests = comments = 0
    for rel, lines in ch.added_lines.items():
        code = [ln for ln in lines if ln.strip()]
        if is_test(rel):
            tests += len(code)
        else:
            src += len(code)
            comments += sum(ln.strip().startswith("#") for ln in code)
    return {
        "new_files": [str(p) for p in ch.new_files],
        "changed_files": [str(p) for p in ch.changed_files],
        "added_source_lines": src,
        "added_test_lines": tests,
        "added_comment_lines": comments,
    }


def size_signals(project: Path, ch: Changes) -> list[str]:
    """Lists ruff's complexity and size warnings for the touched files."""
    if not ch.touched:
        return []

    _, out, _ = run(
        [
            "ruff",
            "check",
            "--no-cache",
            "--preview",
            "--select",
            "C90,PLR09",
            "--exit-zero",
            "--config",
            "lint.mccabe.max-complexity = 8",
            "--config",
            "lint.pylint.max-statements = 30",
            "--config",
            "lint.pylint.max-public-methods = 7",
            "--output-format",
            "concise",
            *map(str, ch.touched),
        ],
        project,
    )
    return [ln for ln in out.splitlines() if re.search(r"C90|PLR09", ln)]


def flatten_outputs(project: Path, outputs: Path, ch: Changes) -> None:
    """Copies touched files into outputs/ as `dir__file.py`, since the viewer only lists top-level files."""
    for old in outputs.glob("*"):
        if old.is_file() and old.name != "report.md":
            old.unlink()
    for rel in ch.touched:
        shutil.copy(project / rel, outputs / str(rel).replace("/", "__"))
    if (project / "pyproject.toml").exists():
        shutil.copy(project / "pyproject.toml", outputs / "pyproject.toml")


def grade_run(spec: Spec, ev: Eval, run_dir: Path) -> str:
    """Grades one run and writes its grading.json and code_metrics.json."""
    project = run_dir / "project"
    fixture = spec.fixture_dir(ev)
    ch = find_changes(project, fixture)

    checks = [
        *tooling_checks(project, fixture),
        check_annotations(ch),
        check_added_lines(
            ch,
            "Code written or changed uses built-in generics and X | None, not List/Dict/Optional/Union",
            LEGACY_TYPING,
        ),
        check_docstrings(ch, project),
        check_docstring_style(ch),
        check_added_lines(ch, "No bare `# type: ignore`", BARE_IGNORE),
        check_added_lines(
            ch,
            "New or changed tests use fakes, not mock.patch / monkeypatch.setattr",
            PATCHING,
            tests_only=True,
        ),
        check_module_names(ch),
        check_spacing(ch, project),
        *hidden_test_checks(spec, ev, project),
        *command_checks(ev, project, run_dir / "outputs" / "report.md"),
    ]
    passed = sum(c.passed for c in checks)
    grading = {
        "expectations": [asdict(c) for c in checks],
        "summary": {
            "passed": passed,
            "failed": len(checks) - passed,
            "total": len(checks),
            "pass_rate": round(passed / len(checks), 4),
        },
    }
    (run_dir / "grading.json").write_text(json.dumps(grading, indent=2))
    metrics = code_metrics(ch) | {"size_signals": size_signals(project, ch)}
    (run_dir / "code_metrics.json").write_text(json.dumps(metrics, indent=2))
    flatten_outputs(project, run_dir / "outputs", ch)

    return f"{passed}/{len(checks)}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--iteration", type=int, default=1)
    parser.add_argument("--only", default="", help="grade only runs whose path contains this text")
    args = parser.parse_args()
    spec = load_spec(args.workspace)

    for ev, _, _, run_dir in spec.runs_of(args.iteration):
        label = run_dir.relative_to(spec.workspace)
        if args.only not in str(run_dir):
            continue
        if not (run_dir / "outputs" / "report.md").exists():
            print(f"{label}: no report yet, skipped")
            continue
        print(f"{label}: {grade_run(spec, ev, run_dir)}")


if __name__ == "__main__":
    main()
