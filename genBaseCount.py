#!/usr/bin/python

import sys

def stringify(baseTuple):
    return "{A: %d, C: %d, G: %d, T: %d}" % (baseTuple[0],
					     baseTuple[1],
					     baseTuple[2],
					     baseTuple[3] )

def main(k):
    baseCounts = []
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
		    count = A_count + C_count + G_count + T_count;
		    if count == k:
			baseCounts.append((A_count,C_count,G_count,T_count))
		    elif count > k:
			break
            
    for i,baseCount in enumerate(baseCounts):
        print("%d\t%s" % (i, stringify(baseCount)) )

def error():

    USAGE = '''ERROR: Please specify kmer length as input parameter
        kmer length must be an integer greater than zero 
        example: ./genBaseCounts 10'''
    
    print(USAGE)
    exit()

if __name__ == "__main__":

    #make sure user passes in kmer size as argument
    if len(sys.argv) < 2:
    	error()
    
    k = 0

    #get Kmer size from command line input and print error if not an int
    try:
        k = int(sys.argv[1])
    except ValueError:
	error()
    
    #print error if kmer size is not positive
    if k <= 0:
	error()

    main(k)
