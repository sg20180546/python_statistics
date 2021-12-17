from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\NATIONAL_YR.xlsx"

WS = pd.read_excel(PATH)

GDP = WS['GDP'].to_numpy().reshape(-1, 1)[7:, :]
CPI = WS['CPI'].to_numpy().reshape(-1, 1)[7:, :]
M2 = WS['M2'].to_numpy().reshape(-1, 1)[7:, :]
Y = M2
R = WS['R'].to_numpy().reshape(-1, 1)[7:, :]
n = Y.shape[0]

ols = linear_model.LinearRegression()
XX = np.hstack((GDP, R, CPI))
ols.fit(XX, Y)

e_t = Y-ols.predict(XX)
# print(e_t)
e_t_minus1 = e_t[:-1, :]
e_t = e_t[1:, :]


ols_AR = linear_model.LinearRegression()
ols_AR.fit(e_t_minus1, e_t)
# print(ols.coef_)
rho = ols_AR.coef_[0][0]
DW = 2*(1-rho)
print(DW)
print(n)
# d_l=1.023, d_u=1.425
print("0<DW<d_l=1.023,양의 자기상관이 있다")
