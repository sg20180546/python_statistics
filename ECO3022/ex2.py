import numpy as np

# 1.Create len(10) integer array filled with zeros
q1=np.zeros(10)
print(q1)

# 2.Create 3x5 floating point array filled with ones
q2=np.ones(15).reshape(3,5)
print(q2)

# 3.Create 3x5 array filled with 3.14
q3=q2*3.14
print(q3)

# 4.Create an array filled with a linear space starting at 0, ending at 20, stepping by 2
q4=np.arange(0,20,2)
print(q4)


# 5.Create an array of five values evenly spaced between 0 and 1
q5=np.linspace(0,1,5)
print(q5)

# 6.Create a 3x3 array of uniformly distributed random (0, 1)
q6=np.random.uniform(0,1,size=9).reshape(3,3)
print(q6)

# 7.Create a 3x3 array of with mean 0 and standard deviation 1
q7=np.random.normal(size=9).reshape(3,3)
print(q7)

# 8.Create a 3x3 array of random integers in the interval [0, 10]
q8=np.random.randint(low=0,high=10,size=9).reshape(3,3)
print(q8)

# 9.Create a 3x3 identity matrix
q9=np.identity(3)
print(q9)