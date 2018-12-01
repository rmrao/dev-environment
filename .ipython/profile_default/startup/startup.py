from random import random

import numpy as np
# import matplotlib.pyplot as plt
import tensorflow as tf

gpu_options = tf.GPUOptions(allow_growth=True)
config = tf.ConfigProto(gpu_options=gpu_options)
tf.enable_eager_execution(config)

np.set_printoptions(suppress=True)
