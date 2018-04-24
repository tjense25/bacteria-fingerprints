#!/bin/bash

#SBATCH --time=15:00:00   # walltime
#SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

#CREATE SPECIES TRAINING SET
#createSpeciesTrainingSetWithMutation.py \
# speciesBPSpath = path to txt file storing all the species BPS\
# K-mer size = size of the kmer read, 10 for our simulation\
# number_of_optical_sequencing_reads = 1000000 (number of reads on prashant hardware)\
# mutation_rate = 0.05 (in line with what is normal for bacteria)\
# number of samples per species = (5,000)\
# number_of_threads
python pyScripts/createSpeciesTrainingSetWithMutations.py \
				bacteria/combinedSpeciesBPS.txt \
				10 \
				1000000 \
				0.05 \
				5000 \
				16 > trainingData/speciesTrainingSet.tsv

#run the classifier on the training with cross validation testing
sbatch -e /dev/null -o output/SPECIES_RESULT shellScripts/runClasifierJob.sh trainingData/speciesTrainingSet.tsv
