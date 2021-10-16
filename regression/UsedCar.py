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

ols = linear_model.LinearRegression()

model = ols.fit(mileage, price)
