import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\NATIONAL_YR.xlsx"

WS = pd.read_excel(PATH)

year = WS['obs'].to_numpy().reshape(-1, 1)
GDP = WS['GDP'].to_numpy().reshape(-1, 1)
CPI = WS['CPI'].to_numpy().reshape(-1, 1)
M2 = WS['M2'].to_numpy().reshape(-1, 1)

RGDP = GDP/(CPI*100)
RM2 = M2/(CPI*100)
N = RGDP.shape[0]
log_rgdp = np.log(RGDP)
log_RM2 = np.log(RM2)
gdp_growth = log_rgdp[1:, :]-log_rgdp[0:-1, :]
RM2_dt = log_RM2[1:, :]-log_RM2[0:-1, :]


ols1 = linear_model.LinearRegression()
model1 = ols1.fit(year[1:, :], gdp_growth)

ols2 = linear_model.LinearRegression()
model2 = ols2.fit(year, RGDP)

ols3 = linear_model.LinearRegression()
model = ols3.fit(RM2_dt, gdp_growth)


maxX = 2020
minX = 1978
dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)


plt.subplot(3, 1, 1)
plt.plot(dt, ols1.predict(dt))
plt.scatter(year[1:], gdp_growth[:])

plt.subplot(3, 1, 2)
plt.plot(dt, ols2.predict(dt))
plt.scatter(year[:], RGDP[:])


plt.subplot(3, 1, 3)
maxX = 1.05*max(RM2_dt)
minX = min(RM2_dt)-0.01*abs(min(RM2_dt))
dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)
plt.plot(dt, ols3.predict(dt))
plt.scatter(RM2_dt[:], gdp_growth[:])


plt.show()
