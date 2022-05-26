import matplotlib.pyplot as plt

x = range(-1000,1000,1)
y1 = values1
y2 = values2
y3 = values3

fig = plt.figure()
ax1 = fig.add_subplot(111)

ax1.scatter(x, y1, s=10, c='b', marker="s", label='Time1')
ax1.scatter(x, y2, s=10, c='r', marker="s", label='Time2')
ax1.scatter(x, y3, s=10, c='g', marker="s", label='Time3')
plt.legend(loc='upper left');
plt.show()
