"""Finds what a run wrote or changed in a Python project, compared with its fixture."""

import ast
import re
from dataclasses import dataclass, field
from pathlib import Path

SKIP_DIRS = {".venv", "__pycache__", ".pytest_cache", ".ruff_cache", ".mypy_cache", ".git"}

type FunctionNode = ast.FunctionDef | ast.AsyncFunctionDef


@dataclass(frozen=True)
class ChangedFunction:
    """A function that is new or whose source differs from the fixture."""

    file: Path
    node: FunctionNode
    qualname: str


@dataclass(frozen=True)
class NewClass:
    """A class that didn't exist in the fixture."""

    file: Path
    node: ast.ClassDef


@dataclass
class Changes:
    """Everything a run added or changed; paths are relative to the project."""

    new_files: list[Path] = field(default_factory=list)
    changed_files: list[Path] = field(default_factory=list)
    functions: list[ChangedFunction] = field(default_factory=list)
    classes: list[NewClass] = field(default_factory=list)
    added_lines: dict[Path, list[str]] = field(default_factory=dict)

    @property
    def touched(self) -> list[Path]:
        """The new and changed files."""
        return [*self.new_files, *self.changed_files]


def is_test(path: Path) -> bool:
    """Returns whether a project-relative path is test code."""
    return path.name.startswith("test_") or "tests" in path.parts or path.name == "conftest.py"


def py_files(root: Path) -> list[Path]:
    """Returns the project's Python files, skipping tool and venv folders."""
    return sorted(p for p in root.rglob("*.py") if not SKIP_DIRS.intersection(p.relative_to(root).parts))


def find_changes(project: Path, fixture: Path) -> Changes:
    """Compares a finished project with the fixture it started from.

    A function counts as changed when its source text differs, so a function
    whose annotation alone was rewritten is judged as code the agent touched.
    An import line that only reordered its names counts as unchanged.

    Args:
        project: The run's finished project.
        fixture: The starting project; may not exist for from-scratch tasks.

    Returns:
        The new and changed files, functions, classes and added lines.
    """
    changes = Changes()
    for path in py_files(project):
        rel = path.relative_to(project)
        before = fixture / rel
        source = path.read_text()
        old_source = before.read_text() if before.exists() else ""
        if source == old_source:
            continue

        (changes.changed_files if before.exists() else changes.new_files).append(rel)
        old_lines = {_normalize(line) for line in old_source.splitlines()}
        changes.added_lines[rel] = [ln for ln in source.splitlines() if _normalize(ln) not in old_lines]
        _collect_defs(changes, rel, source, old_source)

    return changes


def _collect_defs(changes: Changes, rel: Path, source: str, old_source: str) -> None:
    try:
        new_defs = _defs(ast.parse(source), source)
        old_defs = _defs(ast.parse(old_source), old_source) if old_source else {}
    except SyntaxError:
        return

    for name, (node, segment) in new_defs.items():
        if isinstance(node, ast.ClassDef):
            if name not in old_defs:
                changes.classes.append(NewClass(rel, node))
        elif name not in old_defs or old_defs[name][1] != segment:
            changes.functions.append(ChangedFunction(rel, node, name))


def _defs(tree: ast.AST, source: str) -> dict[str, tuple[FunctionNode | ast.ClassDef, str]]:
    found: dict[str, tuple[FunctionNode | ast.ClassDef, str]] = {}

    def walk(node: ast.AST, prefix: str) -> None:
        for child in ast.iter_child_nodes(node):
            if isinstance(child, ast.FunctionDef | ast.AsyncFunctionDef | ast.ClassDef):
                name = f"{prefix}{child.name}"
                found[name] = (child, ast.get_source_segment(source, child) or "")
                walk(child, f"{name}.")

    walk(tree, "")
    return found


def _normalize(line: str) -> str:
    match = re.match(r"\s*from (\S+) import (.+)", line)
    if not match:
        return line

    names = sorted(n.strip() for n in match.group(2).split(","))
    return f"from {match.group(1)} import {', '.join(names)}"
