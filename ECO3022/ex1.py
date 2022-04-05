import numpy as np

# 1)
int_1=4
float_1=3.1415
float_1=1.0
complex_1=2+4j

# 2)
# int float float complex

# 3)
string_1="Python is an interesting and useful language for numerical computing!"

slice_Python=string_1[0:6]
print(slice_Python)
slice_Exclamation_mark=string_1[len(string_1)-1:]
print(slice_Exclamation_mark)
slice_computing=string_1[-10:-1]
print(slice_computing)
slice_reverse=string_1[::-1]
print(slice_reverse)

# 4)
x=np.array([[1,0.5],[0.5,1]])
print(x)

# 5)
y=x
y[0][0]=1.61
print(y)