import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math
WS = pd.read_excel('D:\github\python_statistics\DATA\FIRM.xlsx')


data = np.array(WS).transpose()


profit = data[2, :].reshape(-1, 1)
sales = data[4, :].reshape(-1, 1)
profitRatio = profit/sales
log_Sales = np.log(sales)

ols = linear_model.LinearRegression()

model = ols.fit(log_Sales, profitRatio)

linear_Equation = f'{ols.coef_[0][0]}X  {ols.intercept_[0]}'

print(linear_Equation)
