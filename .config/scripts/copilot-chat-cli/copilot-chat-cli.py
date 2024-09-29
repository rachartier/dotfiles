import argparse
import subprocess

from action import ActionManager
from copilot import chat_with_copilot
from prompt import DEFAULT_SYSTEM_PROMPT

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
        command = action_obj.command

        try:
            if command:
                command = [part.replace("$path", args.path) for part in command]
                process_result = subprocess.run(
                    command,
                    check=True,
                    text=True,
                    capture_output=True,
                )
                prompt += "```diff\n" + process_result.stdout + "\n```"
        except subprocess.CalledProcessError as e:
            print(f"An error occurred: {e}")
            print(f"Command: {' '.join(action_obj.command)}")
            return

    try:
        response = chat_with_copilot(prompt, model, system_prompt)
        print(response)
    except Exception as e:
        print(f"An error occurred: {e}")
        print(f"At line: {e.__traceback__.tb_lineno}")


if __name__ == "__main__":
    main()
