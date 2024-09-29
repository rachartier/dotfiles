from pydantic import BaseModel

from prompt import DEFAULT_SYSTEM_PROMPT


class Action(BaseModel):
    description: str
    prompt: str
    system_prompt: str
    model: str
    command: list[str]


class ActionManager:
    def __init__(self):
        self._actions = {
            "commitizen": Action(
                description="Generate a commit message with Commitizen",
                prompt="""
Generate a professional Git commit message using the Commitizen convention.
Include a commit type from the following options: feat, fix, docs, style, refactor, test, chore, revert.
After the type, add a concise and descriptive commit title that explains what was done in 50 characters or less.
Then, in the body of the commit message, provide a more detailed description of the changes, including what was changed, why it was necessary, and any relevant context for the change.
Do NOT include ``` at the beginning and end of the commit message.
Do NOT include a commit hash or any other metadata in the commit message.
Prefix the commit message with the number of the commit message. Like this:
Use this diff to generate a commit message: ",
                    """,
                system_prompt=DEFAULT_SYSTEM_PROMPT,
                model="gpt-4o",
                command=[
                    "git",
                    "-C",
                    "$path",
                    "diff",
                    "--no-color",
                    "--no-ext-diff",
                ],
            ),
            "lazygit-commitizen": Action(
                description="Generate a commit message with Commitizen",
                prompt="""
Generate 10 professional Git commit messages using the Conventional Commit convention and should follow the format:
type(scope): short description

Where:

- "type" is one of the following: feat, fix, docs, style, refactor, perf, test, chore
- "scope" is optional and indicates the part of the code affected (in parentheses)
- "short description" is a brief explanation of the change in less than 50 characters

The messages should be varied, covering different types of changes and scopes. Ensure each message is concise, clear, and informative.

Do NOT include ``` at the beginning and end of the commit message.
Do NOT include a commit hash or any other metadata in the commit message.

Expected output example:

1: feat(auth): add Google login
2: fix(api): fix pagination bug
3: docs(readme): update installation instructions

You will use the following diff to generate the commit messages:
                    """,
                system_prompt=DEFAULT_SYSTEM_PROMPT,
                model="gpt-4o",
                command=[
                    "git",
                    "-C",
                    "$path",
                    "diff",
                    "--no-color",
                    "--no-ext-diff",
                    "--staged",
                ],
            ),
        }

    def get_action(self, action: str) -> Action:
        if action not in self._actions:
            raise ValueError(f"Invalid action: {action}")
        return self._actions[action]

    def get_actions_list(self):
        return list(self._actions.keys())
