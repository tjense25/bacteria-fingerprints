#!/bin/bash

K=$1
GENE=$2
GENE_FASTA=$(ls $GENE*.fasta)


jellyfish=/fslgroup/fslg_genome/bacteria-fingerprints/jellyfish-2.2.7/jf/bin/jellyfish

$jellyfish count -m $K -s 100M -t 4 -C $GENE_FASTA

$jellyfish dump mer_counts.jf |	../pyScripts/convertToBasePercentageSpace.py $K $GENE > $GENE.bps

rm -rf mer_counts.jf
