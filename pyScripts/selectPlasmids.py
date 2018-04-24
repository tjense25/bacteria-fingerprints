#!/usr/bin/python

import sys
i = 0
outfile = None
for line in sys.stdin:
	if line[0] == '>':
		if outfile: outfile.close()
		outfile = open("controlPlasmids/temp/plasmid%d" % i, 'w')
		outfile.write(line)
		i += 1
	else:
		outfile.write(line)
outfile.close()
