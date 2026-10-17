import httpx

from weather.client import Forecast, fetch_forecast


def test_fetch_forecast_parses_response() -> None:
    transport = httpx.MockTransport(
        lambda request: httpx.Response(200, json={"high_c": 21.5, "low_c": 12.0})
    )
    with httpx.Client(transport=transport) as client:
        assert fetch_forecast(client, "Lyon") == Forecast("Lyon", 21.5, 12.0)
