from numpy import genfromtxt
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

my_data = genfromtxt('data.csv', delimiter=',',skip_header=1)

#print my_data.shape
#print my_data

rowNum = 0
correctedJpt =  my_data[0:1000,2]
measuredJpt = my_data[0:1000,3]
rho = my_data[0:1000,5]
sigma = my_data[0:1000,6]
area = my_data[0:1000,7]
offset1 = (correctedJpt - trueJpt) 
offset2 = (measuredJpt - trueJpt)

trueJptDensity = trueJpt / area

# the histogram of the data
#n, bins, patches = plt.hist(offset1, bins = 100, normed=1, facecolor='red', alpha=0.75)

#n, bins, patches = plt.hist(offset2, bins = 100, normed=1, facecolor='blue', alpha=0.75)

n, bins, patches = plt.hist(correctedJpt - trueJpt, bins = 100, normed=1, facecolor='red', alpha=0.75)

#lm
lm = [1.13869,-0.18134,0.18746,0.18480,12.96576,0.04889]
lmJpt = my_data[0:1000,2:] - 7.71551
(Intercept)          NPV          jpt    jptnoarea          rho        sigma         area     sumtrkPV  
   -7.71551           NA      1.13869     -0.18134      0.18746      0.18480     12.96576      0.04889  
#n, bins, patches = plt.hist(rho, bins = 20, normed=1, facecolor='blue', alpha=0.75)

# add a 'best fit' line
mean = np.average(offset1)
var = np.var(offset1)
y = mlab.normpdf( bins, mean, np.sqrt(var))
l = plt.plot(bins, y, 'r--', linewidth=1)

#plt.scatter(offset1, rho)
#plt.scatter(rho,offset2)
#np.histogram(offset1, bins=np.arange(5), density=True)
#plt.plot(offset2)
#plt.ylabel('some numbers')
plt.show()