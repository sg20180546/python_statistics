import numpy as np

mu = np.array([[1], [2], [3]])
sigma = np.array([[2, -1, 1], [-1, 5, 1], [1, 1, 3]])


g_1 = np.array([[1], [2]])
h_1 = np.array([[1, 1, 2], [-1, 2, 0]])

EXPECT_Z = g_1+np.dot(h_1, mu)
# var(z)=H sigma H'
VAR_Z = np.dot(h_1, np.dot(sigma, h_1.T))

print("E(Z): ", EXPECT_Z)
print("V(Z): ", VAR_Z)

g_2 = np.array([[-1], [3]])
h_2 = np.array([[2, 1, -1], [1, -1, 2]])

EXPECT_W = g_2+np.dot(h_2, mu)
VAR_W = np.dot(h_2, np.dot(sigma, h_2.T))

COV_ZW = np.dot(np.dot(h_1, sigma), h_2.T)
print("E(W): ", EXPECT_W)
print("V(W): ", VAR_W)
print("COV(Z,W): ", COV_ZW)
