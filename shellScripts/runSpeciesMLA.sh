#!/bin/bash

#SBATCH --time=9:00:00   # walltime
#SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

#make trainingData and output dirs if they don't exist
mkdir -p trainingData
mkdir -p output

k=10
if [ $# -ge 1 ] ; then
	k=$1
fi
#CREATE SPECIES TRAINING SET
#createSpeciesTrainingSetWithMutation.py \
# speciesBPSpath = path to txt file storing all the species BPS\
# K-mer size = size of the kmer read\
# number_of_optical_sequencing_reads = 1000000 (number of reads on prashant hardware)\
# mutation_rate = 0.05 (in line with what is normal for bacteria)\
# number of samples per species = (5,000)\
# number_of_threads
python pyScripts/createSpeciesTrainingSetWithMutations.py \
				bacteria/combinedSpeciesBPS_$k.txt \
				$k \
				1000000 \
				0.05 \
				5000 \
				16 > trainingData/speciesTrainingSet_$k.tsv

#run the classifier on the training with cross validation testing
sbatch -e /dev/null -o output/SPECIES_RESULT_$k shellScripts/runClassifierJob.sh trainingData/speciesTrainingSet_$k.tsv
