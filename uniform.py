import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import uniform
x = np.linspace(-2, 10, 100)
y_transform = np.ones(100)

for i in range(100):
    if x[i] >= 0:
        y_transform[i] = np.exp(-x[i])
    else:
        y_transform[i] = 0

a, b = 0, 1

# Varying positional arguments
y1 = uniform.pdf(x, a, b)


plt.plot(x, y1,  alpha=0.7, label=r'Uniform[0,1]')

plt.plot(x, y_transform, alpha=1, label=r'Y=-lnX transform')
plt.legend()
plt.show()
