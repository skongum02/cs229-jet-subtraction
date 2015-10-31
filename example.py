from numpy import genfromtxt
my_data = genfromtxt('data.csv', delimiter=',',skip_header=1)

print my_data.shape
print my_data
