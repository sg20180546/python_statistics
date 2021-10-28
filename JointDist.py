from matplotlib import cm
from mpl_toolkits.mplot3d.axes3d import Axes3D
import numpy as np
import matplotlib.pyplot as plt


def f(x, y):
    Z=np.ones_like()
    # filter1 = np.where((x > 0) & (x < 1))
    # print(x[filter1])
    if 0 < x.all() < 1 and 0 < y.all() < 1:
        return 2/3*(x+2*y)
    else:
        return 0


xgrid = np.linspace(-0.5, 1.5, 100)
ygrid = xgrid
X, Y = np.meshgrid(xgrid, ygrid)

Z = f(X, Y)

# fig = plt.figure()
# # fig.set_size_inches(15, 15)
# ax = plt.axes(projection='3d')
# surf = ax.contour3D(X, Y, Z, 50, cmap=cm.coolwarm)
# # fig.colorbar(surf, shrink=0.5, aspect=5)
# ax.set_xlabel('x')
# ax.set_ylabel('y')
# ax.set_zlabel('z')
# # ax.set_title('3D contour')
# plt.show()
