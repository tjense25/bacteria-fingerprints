#!/usr/bin/python
import sys
import collections
from numpy import random
from functools import partial
from multiprocessing import Pool
from math import factorial as fac
from bisect import bisect_left as floor
from createSpeciesTrainingSet import *
from generateMutationGraph import createMutationGraph

def getSampleProbWithMutation(cumProbList, num_reads, mutationGraph, mutation_rate, iterator):
	random.seed(iterator)
	results = []
	for name, probList in cumProbList:
		bpsCounts = [0] * len(probList)
		for read in random.rand(num_reads):
			index = floor(probList, read*probList[-1])

			#Simulate a random mutation in the kmer read probablistically
			if random.rand() < mutation_rate:
				index = random.choice(mutationGraph[index])

			bpsCounts[index] += 1
		sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ]
		results.append((name, sampleBPS))

	return results


def main(bpsPath, k, num_reads, mutation_rate, num_training_samples, num_threads):

	speciesBPS = loadBPS(bpsPath)
	cumulativeProbList = initCumulativeProbList(speciesBPS)	
	bias = initializeBiasDict(k)
	mutationGraph = createMutationGraph(k)

	writeHeader(k)	
	pool = Pool(num_threads)
	func = partial(getSampleProbWithMutation, cumulativeProbList, num_reads, mutationGraph, mutation_rate)
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
	mutation_rate = float(sys.argv[4])
	num_training_samples = int(sys.argv[5])
	num_threads = int(sys.argv[6])

	main(bpsPath, k, num_reads, mutation_rate, num_training_samples, num_threads)
