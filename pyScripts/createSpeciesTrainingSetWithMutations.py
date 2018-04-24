#!/usr/bin/python
import sys
import collections
from numpy import random
from functools import partial
from multiprocessing import Pool
from createSpeciesTrainingSet import *
from generateMutationGraph import MutationGraph

def getSampleProbWithMutation(speciesBPS, k, num_reads, mutation_rate, splice):
	local_random = random.RandomState(splice[0]) #make random thread-safe and set seed
	mutationGraph = MutationGraph(k, local_random)
	results = []
	for __ in splice:
		for name, count, bps in speciesBPS:
			sys.stderr.write("%d\n" % count)
			bpsCounts = [0] * len(bps)
			for read, num_mutations in zip(local_random.choice(len(bps), num_reads, True, bps), local_random.binomial(k, mutation_rate, num_reads)):
				if num_mutations != 0:
					read = mutationGraph.simulateMutations(read, num_mutations) #probabilistically simulate a mutation by taking random walk through mutation graph
				bpsCounts[read] += 1 #store count of bpsKmers
				
			sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ] #convert counts to frequencies
			results.append((name, sampleBPS))

	return results

def main(bpsPath, k, num_reads, mutation_rate, num_training_samples, num_threads):

	speciesBPS = loadBPS(bpsPath)
	correctedBPS = correctBPSList(speciesBPS) #make sure species BPS adds up to 1	
	bias = initializeBiasDict(k)

	writeHeader(k)	

	#create threads for parallelization
	pool = Pool(num_threads)
	func = partial(getSampleProbWithMutation, correctedBPS, k, num_reads, mutation_rate)
	threadPartition = partitionSamplesBetweenThreads(num_training_samples, num_threads)
	results = pool.map(func, threadPartition) #map function to the pool for threads
	pool.close()
	pool.join()
	
	for threadResult in results:
		for name, bps in threadResult:
			for i,freq in enumerate(bps):
				sys.stdout.write("%f\t" % (freq - bias[i])) #subtract species bias from results
			sys.stdout.write("%s\n" % name)


if __name__ == "__main__":
	bpsPath = sys.argv[1]
	k = int(sys.argv[2])
	num_reads = int(sys.argv[3])
	mutation_rate = float(sys.argv[4])
	num_training_samples = int(sys.argv[5])
	num_threads = int(sys.argv[6])

	main(bpsPath, k, num_reads, mutation_rate, num_training_samples, num_threads)
