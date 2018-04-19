#!/usr/bin/python

import sys
from genBPSkmers import genBPSkmers

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
		print("\t%d ->" % node, neighbors)


if __name__ == "__main__":
	k = int(sys.argv[1])
	main(k)
