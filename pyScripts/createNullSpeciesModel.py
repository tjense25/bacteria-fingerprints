#!/usr/bin/python
import sys
from numpy import random
from functools import partial
from multiprocessing import Pool
from createSpeciesTrainingSet import * 


def getRandomProb(speciesBPS, k, num_reads, iterator):
	n = choose2(k + 3, 3)
	results = []
	#make random instance local to make it thread safe
	local_random = random.Random(iterator) #specify seed to make it comput. reproduc.
	for name, _,_ in speciesBPS:
		bpsCounts = [0] * n
		for i in range(num_reads):
			index = random.randint(0, n - 1)
			bpsCounts[index] += 1
		sampleBPS = [ bpsCounts[i] / float(num_reads) for i in range(len(bpsCounts)) ]
		results.append((name, sampleBPS))

	return results

def main(bpsPath, k, num_reads, num_training_samples, num_threads):
	speciesBPS = loadBPS(bpsPath)
	bias = initializeBiasDict(k)

	writeHeader(k)	
	pool = Pool(num_threads)
	func = partial(getRandomProb, speciesBPS, k, num_reads)
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

	main(bpsPath, k, num_reads, num_training_samples, num_threads)
