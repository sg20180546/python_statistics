import pandas as pd
import numpy as np
from sklearn import linear_model
import matplotlib.pyplot as plt
WS = pd.read_excel('FIRM.xlsx')

data = np.array(WS).transpose()

adv = data[0, :].reshape(-1, 1)
sales = data[4, :].reshape(-1, 1)

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
regression = f'{coef[0][0]}X + {const[0]}'
# plt.legend()


# plt.subplot(2, 1, 1)
plt.plot(dt, predicted, label=regression)

# answ = f'Xmean:{adv_mean} Ymean:{sales_mean} '
# answ2 = f'Xvar:{adv_var} Yvar:{sales_var} correl:'


# plt.subplot(2, 1, 2)
# plt.text(0, 0, answ)
# plt.text(0, 0.3, answ2)

plt.legend()
# plt.show()


def ols(x):
    return coef[0][0]*x+const


residualSum = 0
for i in range(adv.shape[0]):
    residualSum += (ols(adv[i])-sales[i])**2

TSS = 0
for i in range(sales.shape[0]):
    TSS += (sales[i]-sales_mean)**2

print("adv_mean : ", adv_mean)
print("sales_mean : ", sales_mean)
print("adv_var : ", adv_var)
print("sales_var : ", sales_var)
print("corelation", np.corrcoef(sales.transpose(), adv.transpose())[0][1])
print("residual sum: ", residualSum)
print("ESS : ", 1 - (residualSum/TSS))
