from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import scipy.stats
import math
from custom import r2_score_adj, sigma_bi_sq, t_ratio_arr


PATH = r"D:\github\python_statistics\DATA\MOVIE.xlsx"

WS = pd.read_excel(PATH)

aud = WS["AUDIENCE"].to_numpy().reshape(-1, 1)
Y = aud
n = Y.shape[0]
screen = WS['SCREEN'].to_numpy().reshape(-1, 1)
genre = WS['GENRE'].to_numpy().reshape(-1, 1)
month = WS['MONTH'].to_numpy().reshape(-1, 1)
screen_squared = screen**2

ols1 = linear_model.LinearRegression()
ols1.fit(screen_squared, Y)


print("#2 marginal effect of screen to audience")
r2_1 = r2_score(Y, ols1.predict(screen_squared))
print("b2 : ", ols1.coef_)
print("r2 : ", r2_1)
print("r2_adj :", r2_score_adj(r2_1, n, 1))

print("#3,#4 add genre")
XX = np.hstack((screen_squared, genre))
ols2 = linear_model.LinearRegression()
ols2.fit(XX, Y)
r2_2 = r2_score(Y, ols2.predict(XX))
print("r2 : ", r2_2)
print("r2_adj : ", r2_score_adj(r2_2, n, 2))
# print(ols2.coef_)
print("because r2_adj increase, genre is meaningful variable")


print("#5 add season dummy variable")
summer = np.zeros_like(Y)
winter = np.zeros_like(Y)
for i in range(summer.shape[0]):
    if(month[i][0] == 7):
        summer[i][0] = 1
    elif(month[i][0] == 8):
        summer[i][0] = 1
    elif(month[i][0] == 1):
        winter[i][0] = 1
    elif(month[i][0] == 2):
        winter[i][0] = 1
XX_5 = np.hstack((screen_squared, genre, summer, winter))
ols3 = linear_model.LinearRegression()
ols3.fit(XX_5, Y)
print(ols3.intercept_, ols3.coef_)

print("#6 verify dummy variable by t-ratio")
sigma = ols3._residues[0]/(n-5)
XX_const = np.hstack((np.ones_like(Y), XX_5))
sigma_bi_squared = sigma_bi_sq(sigma, XX_const)
# for i in range(XX_const.shape[1]):
#     print(math.sqrt(sigma_bi_squared[i][i]))
# print(np.zeros(10).shape)
t_ratio_array = t_ratio_arr(sigma_bi_squared, ols3.intercept_, ols3.coef_)
print(t_ratio_array)
print("because t_summer=-0.35, t_winter=-1.067, two season variable are not significant")
# print(np.mean(summer), np.mean(winter))
# maxX = 1.05*max(screen_squared)
# minX = min(screen_squared)-0.01*abs(min(screen_squared))
# dt = np.linspace(minX, maxX, 1000).reshape(-1, 1)
# plt.plot(dt, ols1.predict(dt))
# plt.scatter(screen[:], aud[:])
# plt.show()
