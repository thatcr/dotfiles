import logging

import env_config

cfg = env_config.Config()
cfg.apply_log_levels()

import rich
import rich.pretty
import rich.logging
import rich.traceback
from rich.console import Console

console = Console()

rich.pretty.install()
rich.traceback.install(console=console, show_locals=True, width=console.width)

# use rich's nice
FORMAT = "%(message)s"
logging.basicConfig(
    level=logging.NOTSET,
    format=FORMAT,
    datefmt="[%X]",
    handlers=[
        rich.logging.RichHandler(
            level=logging.WARNING,
            console=Console(stderr=True),
            rich_tracebacks=True,
            tracebacks_show_locals=True,
        )
    ],
)
