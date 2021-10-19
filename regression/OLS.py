import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math
WS = pd.read_excel('D:\github\python_statistics\DATA\FIRM.xlsx')


data = np.array(WS).transpose()

adv = data[0, :].reshape(-1, 1)
sales = data[4, :].reshape(-1, 1)
N = adv.shape[0]
# varialbe
adv_mean = round(np.mean(adv), 2)
sales_mean = round(np.mean(sales), 2)
# cov = round(np.cov(adv, sales), 2)
adv_var = round(np.var(adv), 2)
sales_var = round(np.var(sales), 2)


ols = linear_model.LinearRegression()
model = ols.fit(adv, sales)

maxXvar = 1.05*max(adv)
minXvar = min(adv)-0.01*abs(min(adv))

dt = np.linspace(minXvar, 25000, 1000).reshape(-1, 1)


predicted = ols.predict(dt)
coef = ols.coef_
const = ols.intercept_
regression_equation = f'{coef[0][0]}X + {const[0]}'
R2 = r2_score(sales, ols.predict(adv))
X_mean_Subtracted_squared = 0
for i in range(adv.shape[0]):
    X_mean_Subtracted_squared += (adv[i]-adv_mean) ** 2
plt.legend()


# plt.subplot(2, 1, 1)
plt.plot(dt, predicted, label=regression_equation)

# answ = f'Xmean:{adv_mean} Ymean:{sales_mean} '
# answ2 = f'Xvar:{adv_var} Yvar:{sales_var} correl:'


# plt.subplot(2, 1, 2)
# plt.text(0, 0, answ)
# plt.text(0, 0.3, answ2)

plt.legend()
plt.show()


def ols(x):
    return coef[0][0]*x+const


residualSum = 0
for i in range(adv.shape[0]):
    residualSum += (ols(adv[i])-sales[i])**2
variance_predicted = residualSum/(N-2)
variance_b2_prediced = variance_predicted/X_mean_Subtracted_squared

TSS = 0
for i in range(sales.shape[0]):
    TSS += (sales[i]-sales_mean)**2

print("N: {}".format(N))
print("adv_mean : ", adv_mean)
print("sales_mean : ", sales_mean)
print("adv_var : ", adv_var)
print("sales_var : ", sales_var)
print("corelation", np.corrcoef(sales.transpose(), adv.transpose())[0][1])
print("residual sum: ", residualSum)
print("ESS : ", 1 - (residualSum/TSS))
print("R2 {}".format(R2))
print("sigma_predicted {}".format(math.sqrt(variance_predicted[0])))
print("X_mean_Subtracted_squared : {}".format(X_mean_Subtracted_squared))
print("ols predicted model : {}".format(regression_equation))
print("trusted domain for b2 :{} < Beta2 < {} ".format(
    coef[0][0]-math.sqrt(variance_b2_prediced)*1.99, coef[0][0]+math.sqrt(variance_b2_prediced)*1.99))
