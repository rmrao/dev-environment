import numpy as np
import tensorflow as tf

if int(tf.__version__.split('.')[0]) < 2:
    gpu_options = tf.GPUOptions(allow_growth=True)
    config = tf.ConfigProto(gpu_options=gpu_options)
    tf.enable_eager_execution(config)

np.set_printoptions(suppress=True)
