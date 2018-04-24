#!/bin/bash

#SBATCH --time=03:00:00   # walltime
#SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

for mutation_rate in 0.0 0.05 0.1 0.2 0.4 0.6
do
	python pyScripts/createSpeciesTrainingSetWithMutations.py bacteria/combinedSpeciesBPS_10.txt 10 10000 $mutation_rate 2000 16 > trainingData/mutationTest_$mutation_rate.tsv
	sbatch --time=00:30:00 -e /dev/null -o output/mutationTest_$mutation_rate shellScripts/runClassifierJob.sh trainingData/mutationTest_$mutation_rate.tsv 
done
