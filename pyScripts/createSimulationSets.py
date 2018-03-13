#!/usr/bin/python
import sys
import collections
import random
from math import factorial as fac
from bisect import bisect_left as floor

def initCumulativeProbList(lst):
	cumulativeProbList = []	
	total = 0
	for i,prob in enumerate(lst):
		total += prob
		cumulativeProbList.append(total)
	return cumulativeProbList
	
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

def main(name):
	basePercentageProb = []
	sample_size = 1000000

	sys.stdin.readline()
	for line in sys.stdin:
	    line = line.split()
	    basePercentageProb.append(float(line[1]))

	cumulativeProbList = initCumulativeProbList(basePercentageProb)	
	    
	bias = initializeBiasDict(10)
	
	numTrainingSamples = 100000

	for i in range(numTrainingSamples):
		
		sampleProb = [0] * 286
		for sample in range(sample_size):	
			randomProb = random.uniform(0,1)
			index = floor(cumulativeProbList, randomProb)
			sampleProb[index] += 1

		for index,prob in enumerate(sampleProb):
		    sampleProb[index] = (sampleProb[index] / float(sample_size)) - bias[index]
		  
		for prob in sampleProb:
			sys.stdout.write("%f\t" % prob)
		sys.stdout.write("%s\n" % name)


if __name__ == "__main__":
	name = sys.argv[1]
	main(name)
	    