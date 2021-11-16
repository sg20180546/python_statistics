from re import M
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
PATH = r"D:\github\python_statistics\DATA\PITCHER.xlsx"


WS = pd.read_excel(PATH)

# MONEY = (WIN,SAVE,LOSE,YEAR)
money = WS['MONEY'].to_numpy().reshape(-1, 1)
win = WS['WIN'].to_numpy().reshape(-1, 1)
save = WS['SAVE'].to_numpy().reshape(-1, 1)
lose = WS['LOSE'].to_numpy().reshape(-1, 1)
year = WS['YEAR'].to_numpy().reshape(-1, 1)
N = money.shape[0]  # N=115

XX = np.hstack((win, save, lose, year))

ols1 = linear_model.LinearRegression()

model1 = ols1.fit(XX, money)

print(model1.coef_)
print(model1.intercept_)
y_hat = ols1.predict(XX)
R2 = r2_score(money, y_hat)
print(R2)
adjusted_R2 = 1 - (1-R2)*(N-1)/(N-5)
print(adjusted_R2)

F_stat = (R2/(5-1))/((1-R2)/(N-5))
# F(5-1,115-5,0.05)= 2.454
print(F_stat)

y_restricted_hat = np.ones_like(money)*np.mean(money)
# print(y_restricted_hat)
R2_restricted = r2_score(money, y_restricted_hat)
print(R2_restricted)

F_stat_res = ((R2-R2_restricted)/4) / ((1-R2)/(N-5))

print(F_stat_res)

win_minus_lose = win-lose
XX_restricted2 = np.hstack((win_minus_lose, save, year))

ols2 = linear_model.LinearRegression()
ols2.fit(XX_restricted2, money)
y_restricted2_hat = ols2.predict(XX_restricted2)
R2_restricted2 = r2_score(money, y_restricted2_hat)

F_stat = ((R2-R2_restricted2)/2)/((1-R2)/(N-5))

print(F_stat)
