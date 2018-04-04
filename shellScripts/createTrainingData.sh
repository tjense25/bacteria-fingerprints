#!/bin/bash

jellyfish=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/jellyfish-2.2.7/jf/bin/jellyfish
if [ ! -d bps ]
then
	mkdir bps
fi

if [ -d temp ]
then
	rm -rf temp
fi
mkdir temp

PLASMID_REFERENCE=$(ls plasmids)
for PLASMID in $PLASMID_REFERENCE
do
	echo "creating 10mer counts for $PLASMID"
	GENE=$(echo $PLASMID | cut -d '.' -f 1)
	$jellyfish count -m 10 -s 1M -t 4 plasmids/$PLASMID
	$jellyfish dump mer_counts.jf > temp/$GENE.10mers
done

REFERENCE_GENOMES=$(ls bacteria)
for REF in $REFERENCE_GENOMES
do
	NAME=$(echo $REF | cut -d '.' -f 1)
	echo "creating 10mer counts for $NAME"
	$jellyfish count -m 10 -s 10M -t 4 bacteria/$REF
	$jellyfish dump mer_counts.jf > temp/$NAME.10mers
	for PLASMID in None IMP-4 VIM-1 NDM-1 KPC-2 CONTROL
	do
		echo "$NAME+$PLASMID"
		SLURM_ID=$(sbatch shellScripts/submitJob.sh $NAME $PLASMID | awk '{print $4}')
	done

done

rm mer_counts.jf

sbatch -d afterok:$SLURM_ID shellScripts/combine.sh
