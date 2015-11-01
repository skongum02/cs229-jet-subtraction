__author__ = 'veinkong'

# follow the usual sklearn pattern: import, instantiate, fit
from sklearn.linear_model import LinearRegression
import pylab
import matplotlib.pyplot as plt

feature_cols = [3,5,6,7,8, 9, 10,11]
X = my_data[0:800, feature_cols]
y = my_data[0:800, 4]

trueJpt = my_data[800:1000,4]

lm = LinearRegression()
lm.fit(X, y)


predictions = lm.predict(my_data[800:1000, feature_cols])


jpt_offset = my_data[800:1000,2] - trueJpt
jpt_offset_avg = numpy.average(jpt_offset)
jpt_offset_std = numpy.std(jpt_offset)
jjvy_offset = predictions - trueJpt
jjvy_offset_avg = numpy.average(jjvy_offset)
jjvy_offset_std = numpy.std(jjvy_offset)


fig = plt.figure()
ax1 = fig.add_subplot(111)

x_axis = [i for i in range(800, 1000)]

ax1.scatter(x_axis, my_data[800:1000, 2], c='r')
ax1.scatter(x_axis,predictions)
plt.legend(loc='upper left');
plt.show()