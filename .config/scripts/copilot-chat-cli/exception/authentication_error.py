from exception.copilot_client_error import CopilotClientError


class AuthenticationError(CopilotClientError):
    """Raised when authentication fails."""
