#!/usr/bin/python
import sys
import collections
import numpy as np
from numpy import random
from functools import partial
from multiprocessing import Pool
from math import factorial as fac

def correctBPSList(speciesBPS):
	correctedBPSList = []	
	for name, iterator, bps in speciesBPS:
		total = sum(bps)
		correctedBPS = [ (total**-1) * prob for prob in bps ]	
		correctedBPSList.append((name, iterator, correctedBPS))
	return correctedBPSList

def writeHeader(k):
	n = choose2(k + 3, 3)
	for i in range(n):
		sys.stdout.write("%i\t" % i)
	sys.stdout.write("label\n")
	
def partitionSamplesBetweenThreads(num_training_samples, num_threads):
	if num_training_samples % num_threads != 0:
		#add more training samples so it can be evenly divided among threads
		num_training_samples = (num_training_samples // num_threads + 1) * num_threads 
	partitionedIndices = []
	partition_size = num_training_samples // num_threads
	for i in range(num_threads):
		partitionedIndices.append(range(i*partition_size,(i+1)*partition_size))
	return partitionedIndices
	
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

'''Iterate through all possible bspKmer and find the
frequency which they appear given all possible sequence kmers.
Stores these frequencies in bias dictionary'''
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

def getSampleProb(correctedBPS, num_reads, splice):
	local_random = random.RandomState(splice[0]) #make random thread safe & set seed for comp. reproducibility
	results = []
	for __ in splice:
		for name, _, bps in correctedBPS:
			bpsCounts = np.bincount(local_random.choice(len(bps), num_reads, True, bps))
			sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ]
			results.append((name, sampleBPS))

	return results


def main(bpsPath, k, num_reads, num_training_samples, num_threads):

	speciesBPS = loadBPS(bpsPath)
	correctedBPS = correctBPSList(speciesBPS)	
	bias = initializeBiasDict(k)

	writeHeader(k)	
	pool = Pool(num_threads)
	func = partial(getSampleProb, correctedBPS, num_reads)
	threadPartition = partitionSamplesBetweenThreads(num_training_samples, num_threads)
	results = pool.map(func, threadPartition)
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

	main(bpsPath, k, num_reads, num_training_samples, num_threads)
