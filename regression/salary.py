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
X = WS['x'].to_numpy().reshape(-1, 1)
E = WS['e'].to_numpy().reshape(-1, 1)
T = WS['t'].to_numpy().reshape(-1, 1)
sex = WS['SEX'].to_numpy().reshape(-1, 1)
n = Y.shape[0]

XX = np.hstack((X, E, T, sex))
ols = linear_model.LinearRegression()
model = ols.fit(XX, Y)

residues = ols._residues[0]


# exclude sex model
XX_res = np.hstack((X, E, T))
ols2 = linear_model.LinearRegression()
model2 = ols2.fit(XX_res, Y)

residues_res = ols2._residues[0]

# F(1,93-5,0.05)
F_stat = ((residues_res-residues)/1)/(residues/(n-5))
print("F_stat : ", F_stat)  # 41.25120407353369
print("귀무가설 기각")
