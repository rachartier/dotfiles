from exception.copilot_client_error import CopilotClientError


class APIError(CopilotClientError):
    """Raised when API calls fail."""
