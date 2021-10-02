from math import sqrt
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm, chi2_contingency
import scipy.stats as stats
from scipy.stats import chi2
x = np.arange(-10, 10, 0.001)

x_transform = np.ones_like(x)

for i in range(x.shape[0]):
    if(x[i] > 0):
        x_transform[i] = sqrt(x[i])
    else:
        x_transform[i] = 0

y = norm.pdf(x_transform, 0, 1)

for i in range(x.shape[0]):
    tmp = np.reciprocal(np.sqrt(x))*1/2
    y[i] *= tmp[i]


# print(np.reciprocal(np.sqrt(x)))
plt.ylim(0, 1)
plt.grid()
plt.plot(x, norm.pdf(x, 0, 1))
# plt.plot(x, stats.chisquare())
plt.plot(x, y)

plt.show()
