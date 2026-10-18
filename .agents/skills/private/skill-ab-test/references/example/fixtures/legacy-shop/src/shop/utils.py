import os
import sqlite3
from decimal import Decimal, ROUND_HALF_UP

DB_PATH = os.environ.get("SHOP_DB", "shop.db")


def get_conn():
    return sqlite3.connect(DB_PATH)


def money(value):
    return Decimal(value).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


def fmt_eur(value):
    return f"{money(value)} EUR"
