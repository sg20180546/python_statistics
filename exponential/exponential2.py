import numpy as np
import matplotlib.pyplot as plt
import math
import sympy
from sympy import S
from scipy import integrate

x, y = sympy.symbols('x y')
f = sympy.exp(-x)
EX = x*sympy.exp(-x)
EX_2 = x**2*sympy.exp(-x)


def E(X):
    return EX.subs(x, X)


def E_2(X):
    return EX_2.subs(x, X)


def expon_dist_transform(X):
    return Z.subs(x, X)


def P(Z):
    return 1-expon_dist_transform(Z)


mean = integrate.quad(E, 0, S.Infinity)
X_squared = integrate.quad(E_2, 0, S.Infinity)
VAR = X_squared[0]-mean[0]


F = sympy.integrate(f)

a = sympy.Limit(F.subs(x, y), y, S.Infinity)
b = sympy.Limit(F.subs(x, y), y, 0)

c = sympy.Limit(F.subs(x, y), y, 3)

print(a.doit()-c.doit())  # 0.05
# chebyshev : k^2 > P(|X-mu|>k*sigma) , 0.05<0.25
