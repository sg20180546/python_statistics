import numpy as np
import matplotlib.pyplot as plt

plt.style.use('default')
plt.rcParams['figure.figsize'] = (10, 5)
plt.rcParams['font.size'] = 12
plt.rcParams['lines.linewidth'] = 5

ld = 2

x = np.linspace(0, 4, 200)
y = ld*np.exp(-ld*x)
y_transform = np.exp(-x)

plt.plot(x, y, alpha=0.7, label=r'$\lambda$=2')
plt.plot(x, y_transform, alpha=1, label=r'Y=2X transform')
plt.legend()
plt.show()
