import json
import os
import random
from dataclasses import dataclass
from datetime import datetime
from typing import TypedDict

import requests

API_ENDPOINT = "https://api.github.com/copilot_internal/v2/token"
CHAT_ENDPOINT = "https://api.githubcopilot.com/chat/completions"

AUTH_HEADERS = {
    "editor-plugin-version": "copilotchatcli/1.0.0",
    "user-agent": "copilotchatcli/1.0.0",
    "editor-version": "vscode/1.63.0",
}


@dataclass
class CopilotToken:
    annotations_enabled: bool
    chat_enabled: bool
    chat_jetbrains_enabled: bool
    code_quote_enabled: bool
    codesearch: bool
    copilotignore_enabled: bool
    endpoints: dict[str, str]
    expires_at: int
    individual: bool
    nes_enabled: bool
    prompt_8k: bool
    public_suggestions: str
    refresh_in: int
    sku: str
    snippy_load_test_enabled: bool
    telemetry: str
    token: str
    tracking_id: str
    vsc_electron_fetcher: bool
    xcode: bool
    xcode_chat: bool
    enterprise_list: list[int]


class ChatResponse(TypedDict):
    choices: list[dict[str, str]]


class CopilotTokenManager:
    def __init__(self):
        self.oauth_token = self._get_oauth_token()
        self.github_token: CopilotToken | None = None
        self.machine_id = self._generate_machine_id()
        self.session_id = ""

        if os.path.exists("/tmp/copilot_token.json"):
            with open("/tmp/copilot_token.json", "r") as f:
                self.github_token = CopilotToken(**json.load(f))

    def _get_oauth_token(self) -> str:
        config_dir = os.getenv("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
        hosts_file = os.path.join(config_dir, "github-copilot", "hosts.json")

        try:
            with open(hosts_file, "r") as file:
                data = json.load(file)
                for k, v in data.items():
                    if "github.com" in k:
                        return v["oauth_token"]
        except FileNotFoundError:
            raise Exception(
                "GitHub Copilot configuration not found. Please install and run it at least once."
            )

        raise Exception("OAuth token not found in GitHub Copilot configuration.")

    def _generate_machine_id(self) -> str:
        return "".join(random.choice("0123456789abcdef") for _ in range(65))

    def generate_uuid(self) -> str:
        hex_chars = "0123456789abcdef"
        template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
        return "".join(
            random.choice(hex_chars)
            if c == "x"
            else random.choice("89ab")
            if c == "y"
            else c
            for c in template
        )

    def refresh_token(self) -> None:
        self.session_id = (
            f"{self.generate_uuid()}{int(datetime.now().timestamp() * 1000)}"
        )

        response = requests.get(
            API_ENDPOINT,
            headers={
                "Authorization": f"token {self.oauth_token}",
                "Accept": "application/json",
                **AUTH_HEADERS,
            },
            timeout=10000,
        )
        response.raise_for_status()

        self.github_token = CopilotToken(**response.json())

        with open("/tmp/copilot_token.json", "w") as f:
            json.dump(response.json(), f)

    def get_copilot_token(self) -> str:
        if not self.github_token or self.github_token.expires_at < int(
            datetime.now().timestamp()
        ):
            self.refresh_token()

        if not self.github_token:
            raise Exception("Failed to obtain Copilot token")

        return self.github_token.token


def chat_with_copilot(prompt: str, model: str, system_prompt: str) -> str:
    token_manager = CopilotTokenManager()
    token = token_manager.get_copilot_token()

    headers = {
        "Content-Type": "application/json",
        "x-request-id": token_manager.generate_uuid(),
        "vscode-machineid": token_manager.machine_id,
        "vscode-sessionid": token_manager.session_id,
        "Authorization": f"Bearer {token}",
        "Copilot-Integration-Id": "vscode-chat",
        "openai-organization": "github-copilot",
        "openai-intent": "conversation-panel",
        **AUTH_HEADERS,
    }

    body = {
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt},
        ],
        "model": model,
        "stream": False,
    }

    response = requests.post(CHAT_ENDPOINT, headers=headers, json=body)
    response.raise_for_status()

    chat_response: ChatResponse = response.json()
    return chat_response["choices"][0]["message"].get("content", "")
