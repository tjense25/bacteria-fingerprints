#!/bin/bash

#SBATCH --time=00:30:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

for num_read in 1 10 50 100 1000 10000 100000
do
	python pyScripts/createSpeciesTrainingSet.py bacteria/combinedSpeciesBPS.txt 10 $num_read 1000 8 > trainingData/speciesTest_$num_read.tsv
	sbatch --time=00:15:00 -o output/speciesTestResult_$num_read shellScripts/runClassifierJob.sh trainingData/speciesTest_$num_read.tsv 
done
