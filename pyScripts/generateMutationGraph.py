#!/usr/bin/python

import sys
import random
from genBPSkmers import genBPSkmers
from createSpeciesTrainingSet import initializeBiasDict
from math import factorial as fac

def hashKmerTuple(countTuple, k):
	A = (k + 1)**3
	C = (k + 1)**2
	G = (k + 1)
	T = 1

	return A*countTuple[0] + C*countTuple[1] + G*countTuple[2] + T*countTuple[3]


def convertToDict(BPSkmers, k):

	BPSkmerDict = {}
	for i, countTuple in enumerate(BPSkmers):
		key = hashKmerTuple(countTuple, k)
		BPSkmerDict[key] = i

	return BPSkmerDict

def getAdjacentKmers(kmerTuple):
	adjacentKmers = []

	if kmerTuple[0] != 0:
		adjacentKmers.append((kmerTuple[0] - 1, kmerTuple[1] + 1, kmerTuple[2], kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0] - 1, kmerTuple[1], kmerTuple[2] + 1, kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0] - 1, kmerTuple[1], kmerTuple[2], kmerTuple[3] + 1))

	if kmerTuple[1] != 0:
		adjacentKmers.append((kmerTuple[0] + 1, kmerTuple[1] - 1, kmerTuple[2], kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1] - 1, kmerTuple[2] + 1, kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1] - 1, kmerTuple[2], kmerTuple[3] + 1))

	if kmerTuple[2] != 0:
		adjacentKmers.append((kmerTuple[0] + 1, kmerTuple[1], kmerTuple[2] - 1, kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1] + 1, kmerTuple[2] - 1, kmerTuple[3]))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1], kmerTuple[2] - 1, kmerTuple[3] + 1))

	if kmerTuple[3] != 0:
		adjacentKmers.append((kmerTuple[0] + 1, kmerTuple[1], kmerTuple[2], kmerTuple[3] - 1))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1] + 1, kmerTuple[2], kmerTuple[3] - 1))
		adjacentKmers.append((kmerTuple[0], kmerTuple[1], kmerTuple[2] + 1, kmerTuple[3] - 1))
		

	return adjacentKmers

def simulateMutations(mutationGraph, k):
	n = fac(k + 3) // fac(3) // fac(k)
	bpsSpace = [0] * n
	s = 100000
	for i in range(s):
		index = random.randint(0, n -1)
		for j in range(k):
			index = random.choice(mutationGraph[index])
		bpsSpace[index] += 1
	for count in bpsSpace: sys.stdout.write("%.4f " % (count / float(s)))
	print("")
	bpsSpace = [0] * n
	for i in range(s):
		index = 2
		mut_index = 2
		visited = set()
		for j in range(k):
			visited.add(index)
			while mut_index in visited: mut_index = random.choice(mutationGraph[index])
			index = mut_index
		bpsSpace[index] += 1
	for count in bpsSpace: sys.stdout.write("%.4f " % (count / float(s)))
	print("")
	for freq in initializeBiasDict(k): sys.stdout.write("%.4f " % freq)
	

def createMutationGraph(k):
	BPSkmers = genBPSkmers(k)
	BPSkmersDict = convertToDict(BPSkmers, k)
	
	mutationGraph = [ [] for i in BPSkmers ]
	for i,countTuple in enumerate(BPSkmers):
		neighborTuples = getAdjacentKmers(countTuple)

		for neighbor in neighborTuples:
			mutationGraph[i].append(BPSkmersDict[ hashKmerTuple(neighbor, k)])

	return mutationGraph


def main(k):
	mutationGraph = createMutationGraph(k)
	print("Mutation graph for k = %d" % k)
	for node,neighbors in enumerate(mutationGraph):
		print("\t%d -> %s" % (node, str(neighbors)) )
	simulateMutations(mutationGraph, k)


if __name__ == "__main__":
	k = int(sys.argv[1])
	main(k)
