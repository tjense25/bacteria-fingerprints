#!/bin/bash

jellyfish=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/jellyfish-2.2.7/jf/bin/jellyfish
convertToBPS=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/pyScripts/convertToBasePercentageSpace.py

REFERENCE_GENOMES=$(ls bacteria/*.fna)
for REF in $REFERENCE_GENOMES
do
	NAME=$(echo $REF | cut -d '/' -f 2)
	NAME=$(echo $NAME | cut -d '.' -f 1)
	$jellyfish count -m 10 -s 10M -t 4 $REF
	$jellyfish dump mer_counts.jf | $convertToBPS 10 $NAME
done

rm mer_counts.jf
