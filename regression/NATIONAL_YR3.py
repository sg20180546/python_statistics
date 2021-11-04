from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\NATIONAL_YR.xlsx"

WS = pd.read_excel(PATH)

GDP = WS['GDP'].to_numpy().reshape(-1, 1)
CPI = WS['CPI'].to_numpy().reshape(-1, 1)
M2 = WS['M2'].to_numpy().reshape(-1, 1)

RGDP = GDP/(CPI*100)
RM2 = M2/(CPI*100)
N = RGDP.shape[0]

# time lag model
RGDP_lag = RGDP[1:, :]
RM2_lag = RM2[:-1, :]

X = np.hstack((np.ones_like(RM2), RM2))
XX = np.dot(X.T, X)

beta = np.dot(np.linalg.inv(XX), np.dot(X.T, RGDP))

ols = linear_model.LinearRegression()
model = ols.fit(RM2, RGDP)

ols_lag = linear_model.LinearRegression()
model = ols_lag.fit(RM2_lag, RGDP_lag)


RSS = 0
for i in range(N):
    RSS += ((beta[0][0]+beta[1][0]*RM2[i]) - RGDP[i])**2


def ols_predict(x):
    return (beta[0][0]+beta[1][0]*x)


sigma_squared_hat = RSS/(N-2)
sigma_squared_hat_beta = sigma_squared_hat*np.linalg.inv(XX)
sigma_squared_hat_beta2 = math.sqrt(sigma_squared_hat_beta[1][1])

T_VALUE = beta[1][0]/sigma_squared_hat_beta2


maxX = 1.05*max(RM2)
minX = min(RM2)-0.01*abs(min(RM2))
dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)

y_predicted = np.ones_like(dt)
for i in range(dt.shape[0]):
    y_predicted[i] = ols_predict(dt[i])

plt.subplot(2, 1, 1)
plt.plot(dt, y_predicted)
plt.scatter(RM2[:], RGDP[:])


plt.subplot(2, 1, 2)

maxX = 1.05*max(RM2_lag)
minX = min(RM2_lag)-0.01*abs(min(RM2_lag))
dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)

plt.plot(dt, ols_lag.predict(dt))
plt.scatter(RM2_lag[:], RGDP_lag[:])

print("time lag predicted : ", ols.predict([RM2[N-1]]))
print("Real RGDP :", RGDP[N-1])

# print(RM2[N-1])
plt.show()
#
