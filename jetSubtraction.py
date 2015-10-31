__author__ = 'veinkong'

import numpy

def calculateSNR(data, x):
    offsetDiff = numpy.square(data[0:1000,x] - data[0:1000,4])
    x_avg = numpy.average(offsetDiff)
    x_std = numpy.std(offsetDiff)
    return x_avg/x_std
