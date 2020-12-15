import logging

import rich
import rich.pretty
import rich.logging


rich.pretty.install()
__builtins__["print"] = rich.print


FORMAT = "%(message)s"
logging.basicConfig(
    level="NOTSET",
    format=FORMAT,
    datefmt="[%X]",
    handlers=[rich.logging.RichHandler(rich_tracebacks=True)],
)
