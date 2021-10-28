import numpy as np

mu = np.array([[1, 2, 3]]).transpose()
sigma = np.array([[2, -1, 1], [-1, 5, 1], [1, 1, 3]])
h = np.array([[2, 1, -1]]).transpose()
g = 3

EXPECT_Z = 3+np.dot(h.transpose(), mu)
VAR_Z = np.dot(h.T, np.dot(sigma, h))


# print(mu)
# print(sigma)
# print(h)

print(EXPECT_Z)
print(VAR_Z)
