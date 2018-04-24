#!/usr/bin/python

import sys
from numpy import random
from multiprocessing import Pool
from functools import partial
from createSpeciesTrainingSet import *
from generateMutationGraph import createMutationGraph

	

def combinePlasmids(plasmids):
	total = sum(p[1] for p in plasmids)
	freqs = [ p[1] / float(total) for p in plasmids ]
	combinedBPS = []
	for i in range(len(plasmids[0][2])):
		prob = 0	
		for j,p in enumerate(plasmids):
			prob += freqs[j]*p[2][i]
		combinedBPS.append(prob)
	return combinedBPS

def getReadsFromPlasmids(num_reads, mutationGraph, mutation_rate, threadTuples):
	local_random = random.RandomState(threadTuples[0][1]) #make random thread safe and set seed
	results = []
	for plasmidBpsTuple in threadTuples:
		name, iterator, bps = plasmidBpsTuple
		sys.stderr.write("%d\n" % iterator)
		bpsCounts = [0] * len(bps)
		for read, num_mutations in zip(local_random.choice(len(bps), num_reads, True, bps), local_random.binomial(k, mutation_rate, num_reads)):
			mut_read = read
			visited = set()
			for i in range(num_mutations):
				visited.add(read)
				while mut_read in visited: mut_read = local_random.choice(mutationGraph[read]) #randomly traverse mutation graph
				read = mut_read

			bpsCounts[read] += 1 #store count of kmers

		results.append((name, [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ])) #convert counts to frequencies

	return results

def main(targetPlasmidsPath, controlPlasmidsPath, k, num_reads, mutation_rate, num_samples, num_threads):
	targetPlasmids = loadBPS(targetPlasmidsPath)
	controlPlasmids = loadBPS(controlPlasmidsPath)
	bias = initializeBiasDict(k)
	writeHeader(k)

	if num_samples % num_threads != 0:
		num_samples = (num_samples // num_threads + 1)*num_threads

	p = len(targetPlasmids) #number of target plasmids
	samplePlasmids = []
	for i in range(p + 1):
		targetPlasmid = None
		if i < p:
			targetPlasmid = targetPlasmids[i]
		for j in range(num_samples):
			numControlPlasmids = random.randint(1,6)
			plasmids = []

			if targetPlasmid: plasmids.append(targetPlasmid)

			plasmids.extend([ controlPlasmids[i] for i in random.choice(range(len(controlPlasmids)), numControlPlasmids) ])
			combinedBPS = combinePlasmids(plasmids)
				
			name = targetPlasmid[0] if targetPlasmid else "none"
			samplePlasmids.append((name, i*num_samples + j, combinedBPS))
	
	correctedBPS = correctBPSList(samplePlasmids)
	mutationGraph = createMutationGraph(k)

	threadTuples = []
	partition_size = num_samples // num_threads * (p + 1)
	for i in range(num_threads):
		threadTuples.append(correctedBPS[i*partition_size:(i + 1)*partition_size])

	pool = Pool(num_threads) #generate multiple threads
	func = partial(getReadsFromPlasmids, num_reads, mutationGraph, mutation_rate) #create partial function passing in arguments
	results = pool.map(func, threadTuples) #map function to the different threads
	pool.close()
	pool.join()

	for threadResult in results:
		for name, bps in threadResult:
			for i, freq in enumerate(bps):
				sys.stdout.write("%f\t" % (freq - bias[i]))
			sys.stdout.write("%s\n" % name)



if __name__ == "__main__":
	random.seed(1) #set seed for computational reproducibility
	targetPlasmidsPath = sys.argv[1]
	controlPlasmidsPath = sys.argv[2]
	k = int(sys.argv[3])
	num_reads = int(sys.argv[4])
	mutation_rate = float(sys.argv[5])
	num_samples = int(sys.argv[6])
	num_threads = int(sys.argv[7])
	main(targetPlasmidsPath, controlPlasmidsPath, k, num_reads, mutation_rate, num_samples, num_threads)
