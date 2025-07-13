When, and only when writing Python code, use the following rules:
    - Use built-in generic types introduced in PEP 585:
        - Use list instead of List
        - Use dict instead of Dict
        - Use set, tuple, etc., instead of Set, Tuple, etc.
    - Use PEP 604 syntax for optional and union types:
        - Use str | None instead of Optional[str]
        - Use int | str instead of Union[int, str]
    - Do not import List, Dict, Set, Tuple, Optional, or Union from the typing module.
    - Assume Python 3.10+.
