import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
PATH = r"D:\github\python_statistics\DATA\PITCHER.xlsx"


WS = pd.read_excel(PATH)

money = WS['MONEY'].to_numpy().reshape(-1, 1)
win = WS['WIN'].to_numpy().reshape(-1, 1)
win = win*(10/3)

# print(win[4], winratio[4])

LOG_money = np.log(money)

N = win.shape[0]
ols = linear_model.LinearRegression()

model = ols.fit(win, LOG_money)
# model=ols.fit()
# X = np.array([np.ones_like(money)])
X = np.hstack((np.ones_like(win), win))
invXX = np.linalg.inv(np.dot(X.T, X))
beta = np.dot(invXX, np.dot(X.T, LOG_money))

# print(beta)
Y_hat = ols.predict(win)
Y_BAR = np.mean(LOG_money)

ESS = 0
TSS = 0
RSS = 0
for i in range(N):
    ESS += (Y_hat[i]-Y_BAR)**2
    TSS += (LOG_money[i]-Y_BAR)**2
    RSS += (LOG_money[i]-Y_hat[i])**2

R2 = ESS/TSS
print(N)
print(RSS)
# print(R2)
# print(r2_score(LOG_money, Y_hat))
# print(RSS)
