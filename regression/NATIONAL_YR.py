import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\NATIONAL_YR.xlsx"

WS = pd.read_excel(PATH)

data = np.array(WS).transpose()

CPI_i_0 = data[2, :-1].reshape(-1, 1)
CPI_i_1 = data[2, 1:].reshape(-1, 1)
inflation = (CPI_i_1-CPI_i_0)/CPI_i_0*100
M2_i_0 = data[8, :-1].reshape(-1, 1)
M2_i_1 = data[8, 1:].reshape(-1, 1)
M_GROWTH = (M2_i_1-M2_i_0)/M2_i_0*100

N = inflation.shape[0]

ols = linear_model.LinearRegression()

ols.fit(M_GROWTH, inflation)
# ols._residues


def equation(x):
    return ols.coef_[0][0]*x+ols.intercept_[0]


mean_inflation = round(np.mean(inflation), 2)
mean_mGrowth = round(np.mean(M_GROWTH), 2)
x_mean_diff_Squared = 0
for i in range(N):
    x_mean_diff_Squared += (M_GROWTH[i]-mean_mGrowth)**2

linear_equation = f'{ols.coef_[0][0]}X + {ols.intercept_[0]}'
R2 = r2_score(inflation, ols.predict(M_GROWTH))
Y_hat = ols.predict(M_GROWTH)
residuals = inflation-Y_hat
residual_sum_of_squared = residuals.T @ residuals
sigma_squared_hat = residual_sum_of_squared[0, 0]/(N-2)
sigma_b2_squared_hat = sigma_squared_hat/x_mean_diff_Squared


# print
print("sigma_squared_hat : ", sigma_squared_hat)
print("residual_sum_of_squared : ", residual_sum_of_squared)
print("equation : {}".format(linear_equation))
print("mean_inflation :", mean_inflation)
print("mean_mGrowth : ", mean_mGrowth)
print("R2 : ", R2)
print("sigma_b2_hat : ", math.sqrt(sigma_b2_squared_hat))
print("trusted beta_2 scope : {0} < beta_2 < {1}".format(ols.coef_[
      0][0]-1.68*math.sqrt(sigma_b2_squared_hat), ols.coef_[0][0]+1.68*math.sqrt(sigma_b2_squared_hat)))

maxXvar = 1.05*max(M_GROWTH)
minXvar = min(M_GROWTH)-0.01*abs(min(M_GROWTH))

# dt = np.linspace(minXvar, maxXvar, 1000).reshape(-1, 1)
# predicted = ols.predict(dt)
# plt.plot(dt, predicted, label=linear_equation)
# plt.scatter(M_GROWTH[:], inflation[:])
# plt.legend()
# plt.show()


# print(ols.coef_[0][0], ols.intercept_[0])
