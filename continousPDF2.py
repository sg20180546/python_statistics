import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def pdfX(x):
    if x >= 0 and x <= 1:
        return 2*x

    else:
        return 0


def pdfY(x):
    if x >= -1 and x <= 2:
        return 2*(x+1)/9
    else:
        return 0


dctX = {}
dctY = {}
for i in range(-200, 400, 1):
    i = (i)/100
    dctX[i] = pdfX(i)
    dctY[i] = pdfY(i)

labelX = f'$y=2x , y=2(x+1)/{9}$'

pd.Series(dctX).plot()
pd.Series(dctY).plot(xlabel=labelX)

plt.show()
