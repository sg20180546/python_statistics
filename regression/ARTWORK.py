
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import math

PATH = r"D:\github\python_statistics\DATA\ARTWORK.xlsx"

WS = pd.read_excel(PATH)

price = WS['PRICE'].to_numpy().reshape(-1, 1)
Y = price
n = price.shape[0]
age = WS['AGE'].to_numpy().reshape(-1, 1)
die = WS['DIE'].to_numpy().reshape(-1, 1)
med = WS['MEDIIUM'].to_numpy().reshape(-1, 1)
size = WS['SIZE'].to_numpy().reshape(-1, 1)
sup = WS['SUPPORT'].to_numpy().reshape(-1, 1)
corr_price_age = np.corrcoef(price.flatten(), age.flatten())
corr_price_size = np.corrcoef(price.flatten(), size.flatten())
# 2
print("#2 correlation with age,size")
print("price,age : ", corr_price_age[0][1])
print("price,size :{}\nalmost no relation ", corr_price_size[0][1])

print("#3 correlation between die and price")
print("price,die : ", np.corrcoef(price.flatten(), die.flatten())[0][1])


print("#4 correlation between medium and price")
print("price,die : ", np.corrcoef(price.flatten(), med.flatten())[0][1])

print("#5 correlation between support and price")
print("price,die : ", np.corrcoef(price.flatten(), sup.flatten())[0][1])

print("#6 Yi=b1+b2*AGE +b3*AGE^2 + b4*SIZE * b5*DIE")
age_square = age**2
XX = np.hstack((age, age_square, size, die))
ols1 = linear_model.LinearRegression()
model1 = ols1.fit(XX, np.log(Y))
print("intercept : ", ols1.intercept_)
print("coef : ", ols1.coef_)


print("#7 arc,oil,water/ canvas,paper")
arc = np.zeros_like(Y)
oil = np.zeros_like(Y)
water = np.zeros_like(Y)
canvas = np.zeros_like(Y)
paper = np.zeros_like(Y)
for i in range(n):
    if(med[i][0] == 1):
        arc[i][0] = 1
    elif(med[i][0] == 2):
        oil[i][0] = 1
    elif(med[i][0] == 3):
        water[i][0] = 1
    if(sup[i][0] == 1):
        canvas[i][0] = 1
    elif(sup[i][0] == 2):
        paper[i][0] = 1
XX = np.hstack((XX, arc, oil, water, canvas, paper))
ols2 = linear_model.LinearRegression()
model2 = ols2.fit(XX, np.log(Y))
print("intercept : ", ols2.intercept_)
print("coef : ", ols2.coef_)

XX_const = np.hstack((np.ones_like(Y), XX))

sigma_hat_squared = ols2._residues[0]/(n-XX_const.shape[1])
sigma_b_hat_sqaured = sigma_hat_squared * \
    np.linalg.inv(np.dot(XX_const.T, XX_const))

print("\nt_ratio")

for i in range(1, XX_const.shape[1]):
    # print(ols2.coef_[0][i-1])
    # print(math.sqrt(sigma_b_hat_sqaured[i][i]))
    print(ols2.coef_[0][i-1]/math.sqrt(sigma_b_hat_sqaured[i][i]))
# print(sigma_b_hat)
print("arc,water is slightly imporant(|t_ratio|==1.9x),but oil,paper,die are not important explanatory variable")
