import logging
import contextlib
logging.basicConfig(
    format="%(levelname)s - %(name)s -   %(message)s",
    level=logging.INFO)

with contextlib.suppress(ImportError):
    import numpy as np
    np.set_printoptions(suppress=True)


# with contextlib.suppress(ImportError):
    # import torch
    # import torch.nn as nn
    # import torch.nn.functional as F
