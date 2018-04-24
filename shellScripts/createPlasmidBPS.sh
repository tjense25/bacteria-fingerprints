#!/bin/bash
set -e

k=10
if [ $# -ge 1 ] ; then
	k=$1
fi

jellyfish=./jellyfish-2.2.7/jf/bin/jellyfish
convertToBPS=./pyScripts/convertToBasePercentageSpace.py

files=$(ls ./plasmids/*.fasta)

for file in $files
do
	NAME=$(echo $file | cut -d '/' -f 3)
	NAME=$(echo $NAME | cut -d '.' -f 1)
	$jellyfish count -m $k -s 10M -t 4 $file
	$jellyfish dump mer_counts.jf | $convertToBPS $k $NAME
done

rm mer_counts.jf

exit 0

