#!/usr/bin/python
import sys
import collections
from numpy import random
from functools import partial
from multiprocessing import Pool
from math import factorial as fac
from bisect import bisect_left as floor

def initCumulativeProbList(speciesBPS):
	cumulativeProbList = []	
	for name,count,bps in speciesBPS:
		probList = []
		total = 0
		for i,prob in enumerate(bps):
			total += prob
			probList.append(total)
		cumulativeProbList.append((name, probList))
	return cumulativeProbList

def writeHeader(k):
	n = choose2(k + 3, 3)
	for i in range(n):
		sys.stdout.write("%i\t" % i)
	sys.stdout.write("label\n")
	
def choose4(k, w, x, y, z):
	numer = fac(k)
	denom = fac(w)*fac(x)*fac(y)*fac(z)
	return numer // denom

def choose2(a, b):
	numer = fac(a)
	denom = fac(b) * fac(a -b)
	return numer // denom

def loadBPS(BPSPath):
	inFile = open(BPSPath, 'r')
	bps = []
	for line in inFile:
		cols = line.strip().split()
		#create tuple for each sample with (name::str, size::int, bps::List)
		bps.append((cols[0], int(cols[1]), list(map(float, cols[2:]))))
	inFile.close()
	return bps

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
			bias[index] = choose4(k, A_count,C_count,G_count,T_count) / float(4**k)
			index += 1
		    elif count > k:
			break
    return bias

def getSampleProb(cumProbList, num_reads, iterator):
	random.seed(iterator)
	results = []
	for name, probList in cumProbList:
		bpsCounts = [0] * len(probList)
		for read in random.rand(num_reads):
			index = floor(probList, read*probList[-1])
			bpsCounts[index] += 1
		sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ]
		results.append((name, sampleBPS))

	return results


def main(bpsPath, k, num_reads, num_training_samples, num_threads):

	speciesBPS = loadBPS(bpsPath)
	cumulativeProbList = initCumulativeProbList(speciesBPS)	
	bias = initializeBiasDict(k)

	writeHeader(k)	
	pool = Pool(num_threads)
	func = partial(getSampleProb, cumulativeProbList, num_reads)
	results = pool.map(func, range(num_training_samples))
	pool.close()
	pool.join()
	
	for threadResult in results:
		for name, bps in threadResult:
			for i,freq in enumerate(bps):
				sys.stdout.write("%f\t" % (freq - bias[i]))
			sys.stdout.write("%s\n" % name)


if __name__ == "__main__":
	bpsPath = sys.argv[1]
	k = int(sys.argv[2])
	num_reads = int(sys.argv[3])
	num_training_samples = int(sys.argv[4])
	num_threads = int(sys.argv[5])

	main(bpsPath, num_reads, num_training_samples, num_threads)
