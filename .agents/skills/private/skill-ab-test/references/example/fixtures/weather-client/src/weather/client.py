"""Client for the forecast service."""

from dataclasses import dataclass

import httpx

BASE_URL = "https://forecast.example.com/v1"


@dataclass(frozen=True)
class Forecast:
    """A daily forecast for one city."""

    city: str
    high_c: float
    low_c: float


def fetch_forecast(client: httpx.Client, city: str) -> Forecast:
    """Fetches today's forecast for a city.

    Args:
        client: The HTTP client to send the request with.
        city: The city name, as the service spells it.

    Returns:
        Today's forecast.

    Raises:
        httpx.HTTPStatusError: The service answered with an error status.
    """
    response = client.get(f"{BASE_URL}/forecast", params={"city": city})
    response.raise_for_status()

    data = response.json()
    return Forecast(city=city, high_c=data["high_c"], low_c=data["low_c"])
