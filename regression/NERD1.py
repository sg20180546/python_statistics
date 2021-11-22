from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import scipy.stats
import math


PATH = r"D:\github\python_statistics\DATA\NERD.xlsx"

WS = pd.read_excel(PATH)

cost = WS['COST'].to_numpy().reshape(-1, 1)
output = WS['OUTPUT'].to_numpy().reshape(-1, 1)
fuelp = WS['FUELP'].to_numpy().reshape(-1, 1)
wage = WS['WAGE'].to_numpy().reshape(-1, 1)
captial = WS['CAPTP'].to_numpy().reshape(-1, 1)
Y = cost
N = wage.shape[0]
XX = np.hstack((output, fuelp, wage, captial))

# 1) restricted : OUTPUT DOESNT MATTER
print("1) restricted : OUTPUT DOESNT MATTER")
ols1 = linear_model.LinearRegression()
model1 = ols1.fit(XX, Y)
y_hat = ols1.predict(XX)
R2 = r2_score(cost, y_hat)
residues = ols1._residues[0]
print("R2: ", R2)
XX_res1 = np.hstack((fuelp, wage, captial))
ols2 = linear_model.LinearRegression()
ols2.fit(XX_res1, Y)
y_hat_res1 = ols2.predict(XX_res1)
R2_res1 = r2_score(cost, y_hat_res1)
print("Restricted_1 R2: ", R2_res1)
F_stat1 = ((R2-R2_res1)/1)/((1-R2)/N-5)

print("F_stat 1 : ", F_stat1)  #
print("F_stat: -0.17, 귀무가설 기각")

# 2) B_i ==0
print("\n2) H0: B_i ==0")
ols3 = linear_model.LinearRegression()
ols3.fit(np.empty_like(cost), Y)
residues_res2 = ols3._residues[0]
F_stat2 = ((residues_res2-residues)/4)/(residues/(N-5))
print("F_stat 2: ", F_stat2)  # F_stat : 97, 귀무가설 기각
print("귀무가설 기각")

# 3) 2) with R2
print("\n3) 2) with R_squared")
y_hat_res2 = ols3.predict(np.empty_like(cost))
R2_res2 = r2_score(cost, y_hat_res2)
F_stat3 = ((R2-R2_res2)/4)/((1-R2)/(N-5))

print("F_stat 3: ", F_stat3)  # 97
# print(residues)


# 4) capital , fuelp doesnt matter
print("\n4) capital , fuelp doesnt matter")
XX_res4 = np.hstack((output, wage))
ols4 = linear_model.LinearRegression()
ols4.fit(XX_res4, Y)
residues_res4 = ols4._residues[0]
F_stat4 = ((residues_res4-residues)/2)/(residues/(N-5))
print("F_stat 4: ", F_stat4)  # 6.8 ,귀무가설 기각

# 5) 4) with R2
print("\n5) 4) with R2")
y_hat_res4 = ols4.predict(XX_res4)
R2_res4 = r2_score(Y, y_hat_res4)
F_stat4_with_R2 = ((R2-R2_res4)/2)/((1-R2)/(N-5))
print("F_stat4_with_R2: ", F_stat4_with_R2)  # 6.8

# 6)
