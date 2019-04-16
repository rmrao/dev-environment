import numpy as np
import tensorflow as tf

gpu_options = tf.GPUOptions(allow_growth=True)
config = tf.ConfigProto(gpu_options=gpu_options, allow_soft_placement=True)
sess = tf.InteractiveSession(config=config)

np.set_printoptions(suppress=True)
