from numpy import genfromtxt
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

class PileUp {
	def __init__(self, NPV) {
        self.my_data = genfromtxt('data2.csv', delimiter=',',skip_header=1)

	}
}
my_data = genfromtxt('data2.csv', delimiter=',',skip_header=1)



rowNum = 0
trueJpt = my_data[5001:6000,0]
correctedJpt =  my_data[5001:6000,2]
measuredJpt = my_data[5001:6000,3]
rho = my_data[5001:6000,4]
sigma = my_data[5001:6000,5]
area = my_data[5001:6000,6]
sumtrkPV = my_data[5001:6000,7]
sumtrkPU = my_data[5001:6000,8]
offset1 = (correctedJpt - trueJpt) 
offset2 = (measuredJpt - trueJpt)

trueJptDensity = trueJpt / area

# the histogram of the data
'''
n, bins, patches = plt.hist(measuredJpt - trueJpt, bins = 100, normed=1, facecolor='orange', alpha=0.75)

n, bins, patches = plt.hist(correctedJpt - trueJpt, bins = 100, normed=1, facecolor='blue', alpha=0.75)

plt.xlabel('jpt/jptnoarea - trueJpt')
plt.ylabel('numbers of events')
plt.title('area-based correction')

print np.average(measuredJpt - trueJpt), np.average(correctedJpt - trueJpt)
print np.var(measuredJpt - trueJpt), np.var(correctedJpt - trueJpt)

print np.var(area)
print np.var(rho*area)
#lm
#lm = [1.13869,-0.18134,0.18746,0.18480,12.96576,0.04889]
#lmJpt = my_data[0:1000,2:] - 7.71551

# add a 'best fit' line
mean = np.average(offset1)
var = np.var(offset1)
y = mlab.normpdf( bins, mean, np.sqrt(var))
l = plt.plot(bins, y, 'r--', linewidth=1)
'''
f, axarr = plt.subplots(2, 2)
axarr[0, 0].scatter(sumtrkPV, correctedJpt - trueJpt)
axarr[0, 0].set_title('sumtrkPV')
axarr[0, 1].scatter(sumtrkPU, correctedJpt - trueJpt)
axarr[0, 1].set_title('sumtrkPU')
axarr[1, 0].scatter(sigma, correctedJpt - trueJpt)
axarr[1, 0].set_title('sigma')
axarr[1, 1].scatter(rho, correctedJpt - trueJpt)
axarr[1, 1].set_title('rho')
plt.ylabel('jpt - tjpt')
#plt.scatter(rho,offset2)
#np.histogram(offset1, bins=np.arange(5), density=True)
#plt.plot(offset2)
#plt.ylabel('some numbers')
plt.show()