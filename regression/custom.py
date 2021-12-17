import numpy as np
import math


def r2_score_adj(r2, n, k):
    return 1-((1-r2)*(n-1)/(n-k))


def sigma_bi_sq(sigma_sq, XX):
    invXX = np.linalg.inv(np.dot(XX.T, XX))
    return sigma_sq*invXX


def t_ratio_arr(sigma_bi_squared, intercept, coef):
    k = sigma_bi_squared.shape[0]
    t_ratio_array = np.zeros(k)
    # sigma_bi = np.sqrt(sigma_bi_squared)
    t_b1 = intercept[0]/math.sqrt(sigma_bi_squared[0][0])
    # print(t_b1)
    t_ratio_array[0] = t_b1
    for i in range(1, k):
        t_ratio_array[i] = coef[0][i-1]/math.sqrt(sigma_bi_squared[i][i])
    return t_ratio_array
