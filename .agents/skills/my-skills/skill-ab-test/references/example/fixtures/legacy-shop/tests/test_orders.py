from decimal import Decimal
from unittest import mock

from shop.orders import OrderService


@mock.patch("shop.orders.get_conn")
def test_total_adds_tax(get_conn):
    get_conn.return_value.execute.return_value.fetchall.return_value = [
        ("A1", "10.00", 2),
        ("B2", "5.50", 1),
    ]
    service = OrderService()
    assert service.total(1) == Decimal("30.60")
