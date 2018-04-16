#!/bin/bash

files=$(ls ./jellyOutput)
mkdir -p bps
for file in $files
do
	cat ./jellyOutput/$file | ./../pyScripts/convertToBasePercentageSpace.py 10 $file > ./bps/$file
done
