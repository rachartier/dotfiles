import argparse
import subprocess

from action import ActionManager
from constants import DEFAULT_SYSTEM_PROMPT
from copilot import chat_with_copilot

action_manager = ActionManager()


def main() -> None:
    parser = argparse.ArgumentParser(description="CLI for Copilot Chat")
    _ = parser.add_argument(
        "--path",
        type=str,
        help="path to run the action in",
        default=".",
    )
    _ = parser.add_argument(
        "--prompt",
        type=str,
        help="Prompt to send to Copilot Chat",
    )
    _ = parser.add_argument(
        "--model",
        type=str,
        help="Model to use for the chat",
        default="gpt-4o",
    )
    _ = parser.add_argument(
        "--system_prompt",
        type=str,
        help="System prompt to send to Copilot Chat",
        default=DEFAULT_SYSTEM_PROMPT,
    )
    _ = parser.add_argument(
        "--action",
        type=str,
        help="Action to perform",
        choices=action_manager.get_actions_list(),
    )

    args = parser.parse_args()

    prompt: str = args.prompt
    system_prompt: str = args.system_prompt
    model: str | None = args.model
    action: str | None = None

    if args.action:
        action = args.action
        action_obj = action_manager.get_action(action)
        prompt = action_obj.prompt
        system_prompt = action_obj.system_prompt
        model = model or action_obj.model
        commands = action_obj.commands

        if commands:
            for key, command in commands.items():
                try:
                    command = [c.replace("$path", args.path) for c in command]
                    command_result = subprocess.run(
                        command,
                        check=True,
                        text=True,
                        capture_output=True,
                    )

                    prompt = prompt.replace(f"${key}", command_result.stdout)
                except subprocess.CalledProcessError as e:
                    print(f"An error occurred: {e}")
                    print(f"Command: {' '.join(command)}")
                    return

    try:
        response = chat_with_copilot(prompt, model, system_prompt)
        print(response)
    except Exception as e:
        print(f"An error occurred: {e}")
        print(f"At line: {e.__traceback__.tb_lineno}")


if __name__ == "__main__":
    main()
