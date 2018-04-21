#!/usr/bin/python

import sys
from numpy import random
from multiprocessing import Pool
from functools import partial
from bisect import bisect_left as floor
from createSpeciesTrainingSet import initializeBiasDict, writeHeader, loadBPS, initCumulativeProbList
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


def getReadsFromPlasmids(num_reads, mutationGraph, mutation_rate, plasmidBpsTuple):
	name, iterator, bpsProbList = plasmidBpsTuple
	local_random = random.RandomState(iterator) #make random thread safe and set seed
	bpsCounts = [0] * len(bpsProbList)
	for read in local_random.rand(num_reads):
		index = floor(bpsProbList, read*bpsProbList[-1]) #probabilistically select a local_random BPSkmer with replacement

		#probabilistically simulate mutations in the kmer read
		num_mutations = local_random.binomial(k, mutation_rate) #randomly get number of mutations in kmer given mutation rate
		for i in range(num_mutations):
			index = local_random.choice(mutationGraph[index]) #randomly traverse mutation graph

		bpsCounts[index] += 1 #store count of kmers

	sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ] #convert counts to frequencies

	return (name, sampleBPS)

def main(targetPlasmidsPath, controlPlasmidsPath, k, num_reads, mutation_rate, num_samples, num_threads):
	targetPlasmids = loadBPS(targetPlasmidsPath)
	controlPlasmids = loadBPS(controlPlasmidsPath)
	bias = initializeBiasDict(k)
	writeHeader(k)
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
	
	cumulativeBPSList = initCumulativeProbList(samplePlasmids)
	mutationGraph = createMutationGraph(k)

	pool = Pool(num_threads) #generate multiple threads
	func = partial(getReadsFromPlasmids, num_reads, mutationGraph, mutation_rate) #create partial function passing in arguments
	results = pool.map(func, cumulativeBPSList) #map function to the different threads
	pool.close()
	pool.join()

	for name, bps in results:
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
