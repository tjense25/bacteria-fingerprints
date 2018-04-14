#!/usr/bin/python

import sys
i = 0
outfile = None
for line in sys.stdin:
	if line[0] == '>':
		outfile = open("plasmid%d" %i, 'w')
		outfile.write(line)
		i += 1
	else:
		outfile.write(line)
