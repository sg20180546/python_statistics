from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import scipy.stats
import math
import statsmodels.api as sm

from custom import r2_score_adj, sigma_bi_sq, t_ratio_arr


PATH = r"D:\github\python_statistics\DATA\MOVIE.xlsx"

WS = pd.read_excel(PATH)

aud = WS["AUDIENCE"].to_numpy().reshape(-1, 1)
Y = aud
n = Y.shape[0]
screen = WS['SCREEN'].to_numpy().reshape(-1, 1)
director = WS['DIRECTOR'].to_numpy().reshape(-1, 1)
dist = WS['DISTRIBUTOR'].to_numpy().reshape(-1, 1)


XX = np.hstack((screen, director))
ols1 = linear_model.LinearRegression()
ols1.fit(XX, Y)

residual = Y-ols1.predict(XX)

residual_squared_vector = residual**2


# white test
# print(screen*director)
whiteXX = np.hstack((screen, director, screen**2,
                    screen*director, director**2))
ols2_white = linear_model.LinearRegression()
ols2_white.fit(whiteXX, residual_squared_vector)
R2_WHITE = r2_score(residual_squared_vector, ols2_white.predict(whiteXX))
print(R2_WHITE*n)  # 79.8, reject H0 : heterog 이분산


gls_model = sm.GLS()
