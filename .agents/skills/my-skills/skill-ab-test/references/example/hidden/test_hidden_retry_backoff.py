import httpx
import pytest

from weather import client as module


@pytest.fixture(autouse=True)
def no_sleep(monkeypatch):
    monkeypatch.setattr("time.sleep", lambda s: None)


def scripted(*steps):
    calls = []

    def handler(request):
        calls.append(request)
        step = steps[min(len(calls) - 1, len(steps) - 1)]
        if isinstance(step, Exception):
            raise step
        return httpx.Response(step, json={"high_c": 20.0, "low_c": 10.0})

    return httpx.Client(transport=httpx.MockTransport(handler)), calls


def fetch(client):
    try:
        return module.fetch_forecast(client, "Lyon", sleep=lambda s: None)
    except TypeError:
        return module.fetch_forecast(client, "Lyon")


def test_recovers_after_503s():
    client, calls = scripted(503, 503, 200)
    assert fetch(client).high_c == 20.0
    assert len(calls) == 3


def test_recovers_after_timeout():
    client, calls = scripted(httpx.ReadTimeout("slow"), 200)
    assert fetch(client).low_c == 10.0
    assert len(calls) == 2


def test_gives_up_after_three_attempts():
    client, calls = scripted(503)
    with pytest.raises(Exception):
        fetch(client)
    assert len(calls) == 3


def test_no_retry_on_404():
    client, calls = scripted(404)
    with pytest.raises(httpx.HTTPStatusError):
        fetch(client)
    assert len(calls) == 1
