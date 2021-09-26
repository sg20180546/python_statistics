import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import rv_discrete, rv_continuous


def pdf(x):
    if x > 0 and x <= 1:
        return x/2
    elif x > 1 and x <= 2:
        return 1/2
    elif x > 2 and x <= 3:
        return (3-x)/2
    else:
        return 0


def cdf(x):
    if x <= 0:
        return 0
    elif x > 0 and x <= 1:
        return (x**2)/4
    elif x > 1 and x <= 2:
        return 0.5*x-0.25
    elif x > 2 and x <= 3:
        return -0.25*x**2 + 1.5*x - 1.25
    else:
        return 1


def pdf2(x):
    if x > 0:
        return 1/30 * np.exp(-x/30)
    else:
        return 0


def cdf2(x):
    if x > 0:
        return 1-np.exp(-x/30)
    else:
        return 0


cum = {}
dct = {}
for i in range(-100, 500, 1):
    j = (i)/100
    dct[j] = pdf(j)
    cum[j] = cdf(j)

dct2 = {}
cum2 = {}
for i in range(-100, 10000, 1):
    j = (i)/100
    dct2[j] = pdf2(j)
    cum2[j] = cdf2(j)

# pd.Series(dct2).plot()
pd.Series(cum2).plot()

print("at most 19,000km : ", cdf2(19))
print("anywhere from 29,000 to 38,000 kilometers ", cdf2(38)-cdf2(29))
print("at least 48,000 kilometers ", cdf2(48))

plt.show()
