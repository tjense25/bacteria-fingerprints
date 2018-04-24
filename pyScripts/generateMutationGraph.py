#!/usr/bin/python

import sys
import random
from genBPSkmers import genBPSkmers
from numpy import random
from createSpeciesTrainingSet import initializeBiasDict
from math import factorial as fac

class MutationGraph:
	def __init__(self, k, rand=random.RandomState()):
		self.k = k
		self.rand = rand
		self.n = fac(self.k + 3) // fac(3) // fac(self.k)
		self.adjList = self._initAdjList()

	def _initAdjList(self):
		BPSkmers = genBPSkmers(self.k)
		BPSkmersDict = self._convertToDict(BPSkmers)
		
		mutationGraph = [ [] for i in BPSkmers ]
		for i,countTuple in enumerate(BPSkmers):
			neighborTuples = self._getAdjacentKmers(countTuple)

			for neighbor in neighborTuples:
				mutationGraph[i].append(BPSkmersDict[ self._hashKmerTuple(neighbor)])
		return mutationGraph

	
	def _hashKmerTuple(self, countTuple):
		A = (self.k + 1)**3
		C = (self.k + 1)**2
		G = (self.k + 1)
		T = 1

		return A*countTuple[0] + C*countTuple[1] + G*countTuple[2] + T*countTuple[3]


	def _convertToDict(self, BPSkmers):

		BPSkmerDict = {}
		for i, countTuple in enumerate(BPSkmers):
			key = self._hashKmerTuple(countTuple)
			BPSkmerDict[key] = i

		return BPSkmerDict

	def _getAdjacentKmers(self, kmerTuple):
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

	def __str__(self):
		str = []
		BPSkmers = genBPSkmers(self.k)
		for i in range(self.n):
			for j in range(i, self.n):
				if j not in self.adjList[i]: continue
				str.append("A%dC%dG%dT%d ->" % BPSkmers[i] + " A%dC%dG%dT%d" % BPSkmers[j])

		return '\n'.join(str)


	def simulateMutations(self, BPSKmer, numMutations):
		visitedEdges = set()
		mutatedBPSKmer = BPSKmer
		for i in range(numMutations):
			stuck = 0
			while stuck < self.k and (mutatedBPSKmer == BPSKmer or self.n*BPSKmer + mutatedBPSKmer in visitedEdges):
				mutatedBPSKmer = self.rand.choice(self.adjList[BPSKmer])
				stuck += 1
			visitedEdges.add(self.n*BPSKmer + mutatedBPSKmer)
			visitedEdges.add(self.n*mutatedBPSKmer + BPSKmer)
			BPSKmer = mutatedBPSKmer
		return BPSKmer

	
def main(k):
	mutationG = MutationGraph(k)
	print("Mutation graph for k = %d" % k)
	print(mutationG)
	for i in range(1000):
		assert(i % mutationG.n != mutationG.simulateMutations(i % mutationG.n, 2))
	print('success!!')


if __name__ == "__main__":
	k = int(sys.argv[1])
	main(k)
