import logging

import env_config

import rich
import rich.pretty
import rich.logging
import rich.traceback

rich.pretty.install()
rich.traceback.install()

# use rich's nice
FORMAT = "%(message)s"
logging.basicConfig(
    level="INFO",
    format=FORMAT,
    datefmt="[%X]",
    handlers=[rich.logging.RichHandler(rich_tracebacks=True)],
)

cfg = env_config.Config()
cfg.apply_log_levels()
