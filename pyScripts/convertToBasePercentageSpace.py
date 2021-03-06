#!/usr/bin/python
import sys
import collections

def initializeBPDict(k):
    #encoding of base space percentages as a number
    #every different base represents a different order of magnitude 
    A = (k + 1)**3 
    C = (k + 1)**2
    G = (k + 1)**1
    T = (k + 1)**0

    BPSpaceDict = collections.OrderedDict()

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
		    	hash = A*A_count + C*C_count + G*G_count + T*T_count
			BPSpaceDict[hash] = 0
		    elif count > k:
			break

    return BPSpaceDict

def  getBPHash(seq, k):
	#encoding of base space percentages as a number
	#every different base represents a different order of magnitude 
	A = (k + 1)**3 
	C = (k + 1)**2
	G = (k + 1)**1
	T = (k + 1)**0

	BPhash = 0
	reverseHash = 0
	for base in seq:
		if base == 'A':
			BPhash += A
			reverseHash += T
		elif base == 'C':
			BPhash += C
			reverseHash += G
		elif base == 'G':
			BPhash += G
			reverseHash += C
		elif base == 'T':
			BPhash += T
			reverseHash += A

	return (BPhash, reverseHash)

def main(k, name):
	BPSpaceDict = initializeBPDict(k)
	count = 0
	totalCount = 0
	for line in sys.stdin:
		line.strip()
		if line[0] == '>':
			count = int(line[1:])
			totalCount += count * 2
		else:
			BPHash, reverseHash= getBPHash(line, k)
			BPSpaceDict[BPHash] += count
			BPSpaceDict[reverseHash] += count

	total = sum(BPSpaceDict.itervalues())

	for i,key in enumerate(BPSpaceDict):
		BPSpaceDict[key] = BPSpaceDict[key] / float(total) 
	sys.stdout.write("%s %i " % (name, totalCount))
	for i,hash in enumerate(BPSpaceDict):
		sys.stdout.write("%f " % (BPSpaceDict[hash]))
	sys.stdout.write('\n')


def error():

    USAGE = '''ERROR: Please specify kmer length and sequence name
        kmer length must be an integer greater than zero 
        example: cat 10mers.fasta | ./convertToBasePercentageSpace.py 10 IMP-4'''
    
    print(USAGE)
    exit()

if __name__ == "__main__":
    #make sure user passes in kmer size as argument
    if len(sys.argv) < 3:
    	error()
    
    k = 0

    #get Kmer size from command line input and print error if not an int
    try:
        k = int(sys.argv[1])
    except ValueError:
	error()

    name = sys.argv[2]
    
    #print error if kmer size is not positive
    if k <= 0:
	error()

    main(k,name)

