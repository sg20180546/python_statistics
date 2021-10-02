import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

x = np.array([-1, 0, 1])
y = np.array([1/8, 2/8, 5/8])

x1 = np.array([0, 1])
y1 = np.array([2/8, 6/8])
# plt.plot(x, y, 'ro', color='blue')
plt.axis([-1.5, 2, -0.5, 1.3])
plt.plot(x1, y1, 'ro')
plt.show()
