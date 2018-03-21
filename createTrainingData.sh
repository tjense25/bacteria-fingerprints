#!/bin/bash

jellyfish=/fslhome/tjense25/fsl_groups/fslg_genome/bacteria-fingerprints/jellyfish-2.2.7/jf/bin/jellyfish
mkdir combined

REFERENCE_GENOMES=$(ls bacteria)
for REF in $REFERENCE_GENOMES
do
	echo $REF
	$jellyfish count -m 10 -s 10M -t 4 bacteria/$REF
	$jellyfish dump mer_counts.jf > 10mercounts.fasta
	for PLASMID in IMP-4 VIM-1 NDM-1 KPC-2
	do
		echo "$REF+$PLASMID"
		cat 10mercounts.fasta plasmid/Plasmid-$PLASMID*10mer.fasta | pyScripts/convertToBasePercentageSpace.py 10 $REF+$PLASMID > combined/$REF+$PLASMID.bps
		#SLURM_ID=$(sbatch submitJob.sh combined/$REF+$PLASMID | awk '{print $4}')
	done
		
done

#sbatch afterok:$SLURM_ID combine.sh


