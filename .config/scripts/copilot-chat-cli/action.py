from pydantic import BaseModel

from constants import DEFAULT_SYSTEM_PROMPT


class Action(BaseModel):
    description: str
    prompt: str
    system_prompt: str
    model: str
    commands: dict[str, list[str]] | None = None


class ActionManager:
    def __init__(self):
        self._actions = {
            "lazygit-commitizen": Action(
                description="Generate a commit message with Commitizen",
                prompt="""
# AI Commit Message Generator

You are an expert Git user with deep experience in writing meaningful, conventional commit messages. Analyze the following diff and generate diverse, high-quality commit message suggestions.


## Input
```diff
$diff
```

## Context (if available)
Recent commits:
```
$logs
```

## Requirements

Convention: Use Conventional Commits format:

<type>(<optional scope>): <description>
Only use these types: feat, fix, docs, style, refactor, perf, test, chore
Scope is optional and should be relevant

Do not output anything other than the commit message.
Generate one message per line, indexed (e.g., 1:, 2:, 3:).


## Quality Criteria:

Be concise yet descriptive (aim for 50-72 characters)
Start with a lowercase verb
Focus on WHY over WHAT when relevant
Synthesize changes to a higher abstraction level
Avoid redundancy between type/scope and description


## Diversity in Suggestions:

Provide different perspectives and abstraction levels
Include both specific and general messages
Consider various impact types (user-facing, dev experience, performance)


## Example Output Format

1: feat(auth): implement OAuth2 login flow
2: fix(api): resolve race condition in data fetching
3: refactor: simplify error handling logic
4: perf(queries): optimize database joins for faster load

## Advanced Tips

Prioritize user impact over implementation details
If multiple changes exist, try both unified and split approaches
Consider future maintainers reading the git history

Remember: It's better to be insightful and occasionally wrong than consistently obvious. Focus on generating your absolute best suggestion, even if others might be less accurate.

Generate a maximum of 10 commit messages following the format above.
""",
                commands={
                    "diff": [
                        "git",
                        "-C",
                        "$path",
                        "diff",
                        "--no-color",
                        "--no-ext-diff",
                        "--staged",
                    ],
                    "logs": [
                        "git",
                        "-C",
                        "$path",
                        "log",
                        "-n",
                        "10",
                        "--pretty=format:'%h %s'",
                    ],
                },
                system_prompt=DEFAULT_SYSTEM_PROMPT,
                model="gpt-4o",
            ),
        }

    def get_action(self, action: str) -> Action:
        if action not in self._actions:
            raise ValueError(f"Invalid action: {action}")
        return self._actions[action]

    def get_actions_list(self):
        return list(self._actions.keys())
