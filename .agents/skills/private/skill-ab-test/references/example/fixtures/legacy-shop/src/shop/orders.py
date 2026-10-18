from typing import List, Optional, Dict
from decimal import Decimal

from shop.utils import get_conn, money

TAX_RATE = Decimal("0.20")


class OrderService:
    def __init__(self):
        self.conn = get_conn()

    def get_lines(self, order_id):
        cur = self.conn.execute(
            "SELECT sku, unit_price, quantity FROM order_lines WHERE order_id = ?",
            (order_id,),
        )
        return [
            {"sku": sku, "unit_price": Decimal(price), "quantity": qty}
            for sku, price, qty in cur.fetchall()
        ]

    def get_customer(self, order_id) -> Optional[Dict]:
        cur = self.conn.execute(
            "SELECT c.id, c.name, c.vip FROM customers c "
            "JOIN orders o ON o.customer_id = c.id WHERE o.id = ?",
            (order_id,),
        )
        row = cur.fetchone()
        if row is None:
            return None
        return {"id": row[0], "name": row[1], "vip": bool(row[2])}

    def subtotal(self, order_id) -> Decimal:
        lines: List[Dict] = self.get_lines(order_id)
        total = Decimal("0")
        for l in lines:
            total = total + l["unit_price"] * l["quantity"]
        return money(total)

    def total(self, order_id):
        sub = self.subtotal(order_id)
        tax = sub * TAX_RATE
        return money(sub + tax)
