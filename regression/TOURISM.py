from numpy import linalg
import pandas as pd
import numpy as np
from sklearn import linear_model
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import scipy.stats
import math


PATH = r"D:\github\python_statistics\DATA\TOURISM.xlsx"

WS = pd.read_excel(PATH)

comp = WS['COMP'].to_numpy().reshape(-1, 1)
Y = comp
E_comp = np.mean(comp)
pgdp = WS['PGDP'].to_numpy().reshape(-1, 1)
E_pgdp = np.mean(pgdp)
secure = WS['SECURE'].to_numpy().reshape(-1, 1)
E_secure = np.mean(secure)
life = WS['LIFE'].to_numpy().reshape(-1, 1)
E_life = np.mean(life)
unesco = WS['UNESCO'].to_numpy().reshape(-1, 1)
E_unesco = np.mean(unesco)
n = Y.shape[0]

korea = WS.iloc[57, :]

# 1) comparate korea and world mean
print("1) comparate korea and world mean")
print("E(COMP) : {}\nE(pgdp): {}\nE(secure): {}\nE(life): {}\nE(unesco): {}".format(
    E_comp, E_pgdp, E_secure, E_life, E_unesco))
print(korea)

# 2) pearson corrrelation coefficient
print("\n2) pearson corrrelation coefficient")
r_cp = np.corrcoef(comp.flatten(), pgdp.flatten())[0][1]
r_cs = np.corrcoef(comp.flatten(), secure.flatten())[0][1]
r_cl = np.corrcoef(comp.flatten(), life.flatten())[0][1]
r_cu = np.corrcoef(comp.flatten(), unesco.flatten())[0][1]
print("\nr_cp: {}\nr_cs: {}\nr_cl: {}\nr_cu: {}".format(r_cp, r_cs, r_cl, r_cu))

# 3) linear regression
print("\n3) linear regression")
ols = linear_model.LinearRegression()
XX = np.hstack((pgdp, secure, unesco, life))
ols.fit(XX, Y)
print("linear model : Yi={}+{}Xi+ {}Yi + {}Zi + {}Wi".format(
    ols.intercept_[0], ols.coef_[0][0], ols.coef_[0][1], ols.coef_[0][2], ols.coef_[0][3]))


# 4) t-test each coefficient
print("\n4) t-test each coefficient")
sigma_2 = ols._residues[0]/(n-5)
XX = np.hstack((np.ones_like(Y), XX))  # because XX doesnt include intercept
sigma_bi_2 = (np.linalg.inv(np.dot(XX.T, XX)))*sigma_2
t_pgdp = ols.coef_[0][0]/math.sqrt(sigma_bi_2[1][1])
t_secure = ols.coef_[0][1]/math.sqrt(sigma_bi_2[2][2])
t_unesco = ols.coef_[0][2]/math.sqrt(sigma_bi_2[3][3])
t_life = ols.coef_[0][3]/math.sqrt(sigma_bi_2[4][4])
print("t_pgdp: {}\nt_secure: {}\nt_unesco: {}\nt_life: {}".format(
    t_pgdp, t_secure, t_unesco, t_life))  # 5.28 1.81 8.9 5.7
# print(t_secure =1.81 < 2, t_secure doesnt matter)

# 5) if KOREA life secure unchanging,  GDP->38000 unesco->15
print("\n5) if KOREA life secure unchanging,  GDP->38000 unesco->15")
KOR_CUR = np.array([[korea['PGDP'], korea['SECURE'],
                   korea['UNESCO'], korea['LIFE']]])

KOR_CHANGE = np.array([[38000, korea['SECURE'], 15, korea['LIFE']]])
df = ols.predict(KOR_CUR)-ols.predict(KOR_CHANGE)
print(df)  # delta : 428.7
