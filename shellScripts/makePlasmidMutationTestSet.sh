#!/bin/bash

#SBATCH --time=03:00:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

for mutation_rate in .05 .1 .2 .4 .6 .8 .9 .95 1.0
do
	python pyScripts/createPlasmidSamplesWithMutation.py plasmids/targetPlasmids.txt controlPlasmids/controlPlasmidBPS.txt 10 100000 $mutation_rate 2000 8 > trainingData/plasmidMutationTest_$mutation_rate.tsv
	sbatch --time=00:30:00 -e /dev/null -o output/plasmidMutation_$mutation_rate shellScripts/runClassifierJob.sh trainingData/plasmidMutationTest_$mutation_rate.tsv 
done
