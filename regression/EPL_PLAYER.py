import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\EPL_PLAYER.xlsx"

WS = pd.read_excel(PATH, sheet_name=1)

# WS = WS.pars
# print(WS)
appear = WS['APPEARANCE'].to_numpy().reshape(-1, 1)
wage = WS['WAGE'].to_numpy().reshape(-1, 1)

ols = linear_model.LinearRegression()

ols.fit(appear, wage)


maxX = 1.05*max(appear)
minX = min(appear)-0.01*abs(min(appear))
dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)
plt.plot(dt, ols.predict(dt))

plt.scatter(appear[:], wage[:])

plt.show()
