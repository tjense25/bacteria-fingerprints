#!/bin/bash
set -e

k=10
if [ $# -ge 1 ] ; then
	k=$1
fi

mkdir -p controlPlasmids/temp
cat controlPlasmids/controlPlasmids.fna | python pyScripts/selectPlasmids.py

jellyfish=./jellyfish-2.2.7/jf/bin/jellyfish
convertToBPS=./pyScripts/convertToBasePercentageSpace.py

files=$(ls ./controlPlasmids/temp/)

for file in $files
do
	$jellyfish count -m $k -s 10M -t 4 controlPlasmids/temp/$file
	$jellyfish dump mer_counts.jf | $convertToBPS $k $file
done

rm mer_counts.jf
rm -rf ./controlPlasmids/temp

exit 0
