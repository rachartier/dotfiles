import inspect
import json

import dedupe

CANDIDATES = [
    f for name, f in inspect.getmembers(dedupe, inspect.isfunction)
    if not name.startswith("_") and f.__module__ == dedupe.__name__
]


def run(records):
    assert len(CANDIDATES) == 1, [f.__name__ for f in CANDIDATES]
    return list(CANDIDATES[0](records))


def test_keeps_latest_by_real_time_across_offsets():
    records = json.loads("""[
        {"id": "a", "updated_at": "2024-03-01T10:00:00+02:00", "payload": "a-early"},
        {"id": "a", "updated_at": "2024-03-01T09:30:00+00:00", "payload": "a-late"},
        {"id": "b", "updated_at": "2024-03-01T12:00:00Z", "payload": "b-late"},
        {"id": "b", "updated_at": "2024-03-01T11:00:00Z", "payload": "b-early"},
        {"id": "c", "updated_at": "2024-03-01T08:00:00-05:00", "payload": "c-only"}
    ]""")
    by_id = {r["id"]: r["payload"] for r in run(records)}
    assert by_id == {"a": "a-late", "b": "b-late", "c": "c-only"}


def test_one_record_per_id():
    records = [
        {"id": 1, "updated_at": "2024-01-01T00:00:00+00:00", "payload": None},
        {"id": 1, "updated_at": "2024-01-02T00:00:00+00:00", "payload": None},
    ]
    assert len(run(records)) == 1
