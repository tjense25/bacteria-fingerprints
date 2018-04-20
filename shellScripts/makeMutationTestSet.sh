#!/bin/bash

#SBATCH --time=02:00:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

for mutation_rate in .05 .1 .2 .4 .6 .8
do
	python pyScripts/createSpeciesTrainingSetWithMutations.py bacteria/combinedSpeciesBPS.txt 10 10000 $mutation_rate 2000 8 > trainingData/mutationTest_$mutation_rate.tsv
	sbatch --time=01:00:00 -e /dev/null -o output/mutationTest_$mutation_rate shellScripts/runClassifierJob.sh trainingData/mutationTest_$mutation_rate.tsv 
done
