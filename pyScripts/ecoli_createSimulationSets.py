#!/usr/bin/python
import copy
import sys
import collections
from math import factorial as fac
from numpy.random import choice


def choose(k, w, x, y, z):
	numer = fac(k)
	denom = fac(w)*fac(x)*fac(y)*fac(z)
	return numer // denom

def initializeBiasDict(k):
    index = 0
    bias = collections.OrderedDict()
    for A_count in range(k + 1):
        count = A_count

        for C_count in range(k + 1):
            count = A_count + C_count
            if count > k:
                break

            for G_count in range(k + 1):
                count = A_count + C_count + G_count
                if count > k:
                    break

	        for T_count in range(k + 1):
		    count = A_count + C_count + G_count + T_count
		    if count == k:
			bias[index] = choose(k, A_count,C_count,G_count,T_count) / float(4**k)
			index += 1
		    elif count > k:
			break
    return bias

def main():
	basePercentageIndex = []
	count = []
	sample_size = 1000000

	sys.stdin.readline()
	for line in sys.stdin:
	    line = line.split()
	    basePercentageIndex.append(line[0])
	    count.append(float(line[1]))
	    
	bias = initializeBiasDict(10)
	
	numTrainingSamples = 100

	for i in range(numTrainingSamples):
		
		sampleProb = collections.defaultdict(int)
		for sample in sample_size:	
			draw = choice(basePercentageIndex, 1, p=count)
			sampleProb[sample] += 1

		for key in sampleProb:
		    sampleProb[key] = sampleProb[key] / float(sample_size) - bias[key]
		  
		for key in sampleProb:
			sys.stdout.write("%f\t" % sampleProb[key])
		sys.stdout.write("ecoli\n")


if __name__ == "__main__":
	main()
	    
