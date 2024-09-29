from typing import Callable

from pydantic import BaseModel

from prompt import DEFAULT_SYSTEM_PROMPT


class Action(BaseModel):
    description: str
    prompt: str
    system_prompt: str
    model: str
    command: list[str]
    callback: Callable[[str], str] = lambda x: x


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
                callback=lambda response: f"```diff\n{response}\n```",
            ),
            "lazygit-commitizen": Action(
                description="Generate a commit message with Commitizen",
                prompt="""
Generate an appropriate number (maximum 10) of professional Git commit messages using the Conventional Commits convention. Each message should follow the format:

<index>: <type>(<scope>): <short description>

Where:
- <index> is the commit number (1:, 2:, 3:, etc.)
- <type> is one of the following: feat, fix, docs, style, refactor, perf, test, chore
- <scope> is optional and indicates the part of the code affected (in parentheses)
- <short description> is a concise explanation of the change in less than 50 characters

Guidelines:
1. Base the messages ONLY on the provided diff.
2. Ensure each message is concise, clear, and informative.
3. DO NOT repeat the same message multiple times.
4. DO NOT include ``` delimiters at the beginning or end of the messages.
5. DO NOT include commit hashes or other metadata.
6. Sort the messages in the most logical order, with the most important changes first.
7. Stick to the specified types (feat, fix, docs, style, refactor, perf, test, chore).
8. Ensure each message starts with its index (1:, 2:, 3:, etc.).
9. The short description should be in the imperative present tense (e.g., "add" instead of "added").
10. Use the most logical types and scopes for each change. Do not force a type or scope if it doesn't fit.
11. If there is no diff, provide this message "No changes to generate commit messages from."

Expected output example:
1: feat(auth): add Google login
2: fix(api): correct pagination bug
3: docs(readme): update installation instructions

Use the following diff to generate the commit messages:
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
                callback=lambda response: f"```diff\n{response}\n```",
            ),
        }

    def get_action(self, action: str) -> Action:
        if action not in self._actions:
            raise ValueError(f"Invalid action: {action}")
        return self._actions[action]

    def get_actions_list(self):
        return list(self._actions.keys())
