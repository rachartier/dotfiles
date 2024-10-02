"""
GitHub Copilot Client

A professional Python implementation for interacting with GitHub Copilot's API.
This module provides functionality to authenticate and communicate with the Copilot service.
"""

import json
import os
import uuid
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import TypedDict

import requests
from requests.exceptions import RequestException


# API Constants
class APIEndpoints:
    TOKEN = "https://api.github.com/copilot_internal/v2/token"
    CHAT = "https://api.githubcopilot.com/chat/completions"


class Headers:
    AUTH = {
        "editor-plugin-version": "copilotchatcli/1.0.0",
        "user-agent": "copilotchatcli/1.0.0",
        "editor-version": "vscode/1.83.0",
    }


# Type Definitions
@dataclass(frozen=True)
class CopilotToken:
    """Represents a GitHub Copilot authentication token and its associated metadata."""

    token: str
    expires_at: int
    refresh_in: int
    endpoints: dict[str, str]
    tracking_id: str
    sku: str

    # Feature flags
    annotations_enabled: bool
    chat_enabled: bool
    chat_jetbrains_enabled: bool
    code_quote_enabled: bool
    codesearch: bool
    copilotignore_enabled: bool
    individual: bool
    nes_enabled: bool
    prompt_8k: bool
    snippy_load_test_enabled: bool
    vsc_electron_fetcher: bool
    xcode: bool
    xcode_chat: bool

    # Metadata
    public_suggestions: str
    telemetry: str
    enterprise_list: list[int]


class ChatMessage(TypedDict):
    role: str
    content: str


class ChatChoice(TypedDict):
    message: ChatMessage


class ChatResponse(TypedDict):
    choices: list[ChatChoice]


class CopilotClientError(Exception):
    """Base exception for all client-related errors."""


class AuthenticationError(CopilotClientError):
    """Raised when authentication fails."""


class APIError(CopilotClientError):
    """Raised when API calls fail."""


class GithubCopilotClient:
    """Client for interacting with GitHub Copilot's API."""

    def __init__(self) -> None:
        self._oauth_token: str | None = None
        self._copilot_token: CopilotToken | None = None
        self._machine_id: str = str(uuid.uuid4())
        self._session_id: str = ""

        self._load_cached_token()

    def _load_cached_token(self) -> None:
        """Attempts to load a cached Copilot token."""
        cache_path = Path("/tmp/copilot_token.json")
        if cache_path.exists():
            try:
                token_data = json.loads(cache_path.read_text())
                self._copilot_token = CopilotToken(**token_data)
            except (json.JSONDecodeError, TypeError):
                cache_path.unlink(missing_ok=True)

    def _load_oauth_token(self) -> str:
        """Loads the OAuth token from the GitHub Copilot configuration."""
        config_dir = os.getenv("XDG_CONFIG_HOME", Path.home() / ".config")
        hosts_file = Path(config_dir) / "github-copilot" / "hosts.json"

        try:
            hosts_data = json.loads(hosts_file.read_text())
            for key, value in hosts_data.items():
                if "github.com" in key:
                    return value["oauth_token"]
        except (FileNotFoundError, json.JSONDecodeError, KeyError):
            raise AuthenticationError("GitHub Copilot configuration not found or invalid.")

        raise AuthenticationError("OAuth token not found in GitHub Copilot configuration.")

    def _get_oauth_token(self) -> str:
        """Gets or loads the OAuth token."""
        if not self._oauth_token:
            self._oauth_token = self._load_oauth_token()
        return self._oauth_token

    def _refresh_copilot_token(self) -> None:
        """Refreshes the Copilot token using the OAuth token."""
        self._session_id = f"{uuid.uuid4()}{int(datetime.now(UTC).timestamp() * 1000)}"

        headers = {
            "Authorization": f"token {self._get_oauth_token()}",
            "Accept": "application/json",
            **Headers.AUTH,
        }

        try:
            response = requests.get(APIEndpoints.TOKEN, headers=headers, timeout=10)
            response.raise_for_status()
            token_data = response.json()

            self._copilot_token = CopilotToken(**token_data)

            # Cache the token
            cache_path = Path("/tmp/copilot_token.json")
            _ = cache_path.write_text(json.dumps(token_data))

        except RequestException as e:
            raise APIError(f"Failed to refresh Copilot token: {str(e)}") from e

    def _ensure_valid_token(self) -> None:
        """Ensures a valid Copilot token is available."""
        current_time = int(datetime.now(UTC).timestamp())

        if not self._copilot_token or current_time >= self._copilot_token.expires_at:
            self._refresh_copilot_token()

        if not self._copilot_token:
            raise AuthenticationError("Failed to obtain Copilot token")

    def chat_completion(self, prompt: str, model: str, system_prompt: str) -> str:
        """
        Sends a chat completion request to the Copilot API.

        Args:
            prompt: The user's input prompt
            model: The model to use for completion
            system_prompt: The system prompt to guide the model's behavior

        Returns:
            The model's response as a string

        Raises:
            APIError: If the API request fails
        """
        self._ensure_valid_token()

        headers = {
            "Content-Type": "application/json",
            "x-request-id": str(uuid.uuid4()),
            "vscode-machineid": self._machine_id,
            "vscode-sessionid": self._session_id,
            "Authorization": f"Bearer {self._copilot_token.token}",
            "Copilot-Integration-Id": "vscode-chat",
            "openai-organization": "github-copilot",
            "openai-intent": "conversation-panel",
            **Headers.AUTH,
        }

        body = {
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt},
            ],
            "model": model,
            "stream": False,
        }

        try:
            response = requests.post(APIEndpoints.CHAT, headers=headers, json=body)
            response.raise_for_status()

            chat_response: ChatResponse = response.json()
            return chat_response["choices"][0]["message"]["content"]

        except RequestException as e:
            raise APIError(f"Chat completion request failed: {str(e)}") from e


# Example usage
def example_usage() -> None:
    client = GithubCopilotClient()
    try:
        response = client.chat_completion(prompt="What is Python?", model="gpt-4", system_prompt="You are a helpful assistant.")
        print(response)
    except CopilotClientError as e:
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    example_usage()
