#!/usr/bin/python

import sys
import random
from createSpeciesTrainingSet import initializeBiasDict

def writeHeader():
	for i in range(1,287):
		sys.stdout.write("%i\t" % i)
	sys.stdout.write("label\n")
	

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


def loadBPS(BPSPath):
	inFile = open(BPSPath, 'r')
	bps = []
	for line in inFile:
		cols = line.strip().split()
		#create tuple for each sample with (name::str, size::int, bps::List)
		bps.append((cols[0], int(cols[1]), list(map(float, cols[2:]))))
	inFile.close()
	return bps

def main(targetPlasmidsPath, controlPlasmidsPath):
	targetPlasmids = loadBPS(targetPlasmidsPath)
	controlPlasmids = loadBPS(controlPlasmidsPath)
	bias = initializeBiasDict(10)
	writeHeader()
	for i in range(5):
		targetPlasmid = None
		if i < 4:
			targetPlasmid = targetPlasmids[i]
		for i in range(1000):
			numControlPlasmids = random.randint(1,5)
			plasmids = []

			if targetPlasmid: plasmids.append(targetPlasmid)

			plasmids.extend(random.sample(controlPlasmids, numControlPlasmids))
			combinedBPS = combinePlasmids(plasmids)
			for i,b in enumerate(combinedBPS):
				sys.stdout.write("%f\t" % (b - bias[i]))
			sys.stdout.write("%s\n" % (targetPlasmid[0] if targetPlasmid else "none"))

if __name__ == "__main__":
	targetPlasmidsPath = sys.argv[1]
	controlPlasmidsPath = sys.argv[2]
	print(targetPlasmidsPath, controlPlasmidsPath)
	main(targetPlasmidsPath, controlPlasmidsPath)
