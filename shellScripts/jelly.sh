#!/bin/bash

jellyfish=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/jellyfish-2.2.7/jf/bin/jellyfish
convertToBPS=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/pyScripts/convertToBasePercentageSpace.py
mkdir -p jellyOutput 

files=$(ls ./plasmids/*.fasta)

for file in $files
do
	NAME=$(echo $file | cut -d '/' -f 3)
	NAME=$(echo $NAME | cut -d '.' -f 1)
	$jellyfish count -m 10 -s 10M -t 4 $file
	$jellyfish dump mer_counts.jf | $convertToBPS 10 $NAME
done

exit 0

