import numpy as np

STUDY = np.array([[21], [24], [26], [27], [29], [25], [25], [30]])
GPA = np.array([2.8, 3.4, 3.0, 3.5, 3.6, 3.0, 2.7, 3.7]).transpose()
vector8_1 = np.ones([8, 1])


A = np.hstack((vector8_1, STUDY))
A_transpose = A.transpose()

# Beta_hat = (A'A)^-1 A'b, (X'X)^-1X'b,
temp = np.linalg.inv(np.dot(A_transpose, A))
temp = np.dot(temp, A_transpose)
Beta = np.dot(temp, GPA)
# print(Beta)

# GPA_hat
GPA_hat = np.dot(A, Beta)
print(GPA_hat)
residual = GPA-GPA_hat
print(residual)


# USE
# temp = np.linalg.inv(np.dot(A_transpose, A))  # (AT A)-1
# temp = np.dot(A, temp)
# temp = np.dot(temp, A_transpose)
# GPA_hat = np.dot(temp, GPA)
