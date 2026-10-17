"""Reads the test spec and locates the folders of a skill A/B test workspace."""

import json
from collections.abc import Iterator
from dataclasses import dataclass
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parent.parent


@dataclass(frozen=True)
class HiddenTest:
    """A behaviour test the agents never see, copied in only while grading."""

    file: str
    dest: str
    text: str


@dataclass(frozen=True)
class CommandCheck:
    """A pass/fail shell command run in the finished project."""

    text: str
    cmd: str
    max_seconds: float | None = None


@dataclass(frozen=True)
class Eval:
    """One task given to every setup."""

    id: int
    name: str
    fixture: str
    prompt: str
    hidden_tests: tuple[HiddenTest, ...] = ()
    checks: tuple[CommandCheck, ...] = ()

    @property
    def slug(self) -> str:
        """The eval's folder name."""
        return f"eval-{self.id}-{self.name}"


@dataclass(frozen=True)
class Spec:
    """The whole test: setups to compare, tasks and runs per setup."""

    workspace: Path
    configs: dict[str, tuple[str, ...]]
    evals: tuple[Eval, ...]
    runs: int

    def iteration_dir(self, iteration: int) -> Path:
        """Returns the folder holding one iteration's runs."""
        return self.workspace / f"iteration-{iteration}"

    def fixture_dir(self, ev: Eval) -> Path:
        """Returns the starting project for an eval."""
        return self.workspace / "fixtures" / ev.fixture

    def runs_of(self, iteration: int) -> Iterator[tuple[Eval, str, int, Path]]:
        """Yields every (eval, config, run number, run folder) of an iteration."""
        for ev in self.evals:
            for config in self.configs:
                for run in range(1, self.runs + 1):
                    yield ev, config, run, self.iteration_dir(iteration) / ev.slug / config / f"run-{run}"


def load_spec(workspace: Path) -> Spec:
    """Reads `evals.json` from a workspace.

    Args:
        workspace: The test workspace folder.

    Returns:
        The parsed spec.

    Raises:
        FileNotFoundError: The workspace has no `evals.json`.
    """
    data = json.loads((workspace / "evals.json").read_text())
    evals = tuple(
        Eval(
            id=item["id"],
            name=item["name"],
            fixture=item.get("fixture", item["name"]),
            prompt=item["prompt"],
            hidden_tests=tuple(HiddenTest(**h) for h in item.get("hidden_tests", [])),
            checks=tuple(CommandCheck(**c) for c in item.get("checks", [])),
        )
        for item in data["evals"]
    )
    configs = {name: tuple(paths) for name, paths in data["configs"].items()}

    return Spec(workspace.resolve(), configs, evals, data.get("runs_per_config", 2))
