import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\USEDCAR.xlsx"


WS = pd.read_excel(PATH)
price = WS['PRICE'].to_numpy().reshape(-1, 1)
# price = price[0, :]
mileage = WS['MILEAGE'].to_numpy().reshape(-1, 1)
N = mileage.shape[0]
ols = linear_model.LinearRegression()

model = ols.fit(mileage, price)

price_mean = np.mean(price)
mileage_mean = np.mean(mileage)
price_var = np.var(price)
mileage_var = np.var(mileage)

y_hat = ols.predict(mileage)

residual_sum = 0
for i in range(N):
    residual_sum += (y_hat[i]-price[i])**2
sigma_hat = residual_sum/(N-2)

# X_MSE = np.square(np.subtract(mileage_mean, mileage)).mean()
# Y_MSE = np.square(np.subtract(price_mean, price)).mean()
# cov_matrix = np.cov(price, mileage)
XY_MSE = 0

for i in range(N):
    XY_MSE += (price[i]-price_mean)*(mileage[i]-mileage_mean)

XY_MSE = XY_MSE/(N-2)

ols_equation = f'{ols.coef_[0][0]}X + {ols.intercept_[0]}'
R2 = r2_score(price, y_hat)
print("N ", N)
# print("XY_MSE ", XY_MSE)
# print("X_MSE ", X_MSE)
# print("Y_MSE ", Y_MSE)
print("price_mean  {}".format(price_mean))
print("mileage_mean {}".format(mileage_mean))
print("price_var {}" .format(price_var))
print("mileage_var {}".format(mileage_var))
print("sigma_hat : {}".format(math.sqrt(sigma_hat)))
print("Correlation : {}".format(
    XY_MSE/(math.sqrt(price_var)*math.sqrt(mileage_var))))
print("Y_hat = {}".format(ols_equation))
print("R2 : {}".format(R2))
print("f(20000) = ", ols.predict(np.array([20000]).reshape(-1, 1)))

maxX = 1.05*max(mileage)
minXvar = min(mileage)-0.01*abs(min(mileage))

dt = np.linspace(minXvar, maxX, 1000).reshape(-1, 1)

plt.plot(dt, ols.predict(dt))

plt.scatter(mileage[:], price[:])

plt.show()


# print("correlation XY {}".format(XY_MSE / (math.sqrt(X_MSE) * math.sqrt(Y_MSE))))

# print(cov_matrix)
