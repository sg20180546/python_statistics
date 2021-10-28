import numpy as np

# from regression.scalarLinear import EXPECT_Z

g = np.array([[1], [-1], [1], [3]])
H = np.array([[1, 1, 1], [-1, 1, 2], [2, 0, 1], [1, -1, 2]])
mu = np.array([[1], [2], [3]])
sigma = np.array([[2, -1, 1], [-1, 5, 1], [1, 1, 3]])

EXPECT_Z = g+np.dot(H, mu)
VAR_Z = np.dot(np.dot(H, sigma), H.T)

print(EXPECT_Z)
print(VAR_Z)


g_2 = np.array([[2], [1], [-1]])
H_2 = np.array([[1, 0, 1], [-1, 1, 1], [0, 1, 2]])

COV_z1_z2 = np.dot(np.dot(H, sigma), H_2.T)
print(COV_z1_z2)
