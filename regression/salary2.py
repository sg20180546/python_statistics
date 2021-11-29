from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import scipy.stats
import math


PATH = r"D:\github\python_statistics\DATA\salary.xlsx"

WS = pd.read_excel(PATH)

Y = WS['y'].to_numpy().reshape(-1, 1)
n = Y.shape[0]
EDU = WS['x'].to_numpy().reshape(-1, 1)
EXP = WS['e'].to_numpy().reshape(-1, 1)
TEN = WS['t'].to_numpy().reshape(-1, 1)
DUM = WS['SEX'].to_numpy().reshape(-1, 1)

for i in range(n):
    DUM[0][i] = ~DUM[0][i]
DUMTEN = DUM*TEN


XX = np.hstack((DUM, EDU, EXP, TEN, DUMTEN))

ols1 = linear_model.LinearRegression()
model1 = ols1.fit(XX, Y)
print(ols1.coef_, ols1.intercept_)
