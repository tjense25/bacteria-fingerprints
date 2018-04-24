#!/bin/bash

jellyfish=./jellyfish-2.2.7/jf/bin/jellyfish
convertToBPS=./pyScripts/convertToBasePercentageSpace.py

k=10
if [ $# -ge 1 ] ; then
	k=$1
fi

echo k


REFERENCE_GENOMES=$(ls bacteria/*.fna)
for REF in $REFERENCE_GENOMES
do
	NAME=$(echo $REF | cut -d '/' -f 2)
	NAME=$(echo $NAME | cut -d '.' -f 1)
	$jellyfish count -m $k -s 10M -t 4 $REF
	$jellyfish dump mer_counts.jf | $convertToBPS $k $NAME
done

rm mer_counts.jf
