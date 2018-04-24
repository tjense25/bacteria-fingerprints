#!/bin/bash

#SBATCH --time=6:00:00   # walltime
#SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

#createPlasmidSamplesWithMutation.py \
# targetPlasmidBPSPath \
# controLPlasmidBPSpath \
# K-mer size \
# number_of_optical_sequencing_reads \
# mutation_rate \
# number_of_threads
python pyScripts/createPlasmidSamplesWithMutation.py \
				plasmids/targetPlasmids.txt \
				controlPlasmids/controlPlasmidBPS.txt \
				10 \
				1000000 \
				0.05 \
				5000 \
				16 > trainingData/plasmidTrainingSet.tsv

#run cross validation job on new plasmid training data
sbatch -e /dev/null -o output/PLASMID_CV_RESULT shellScripts/runClassifierJob.sh trainingData/plasmidTrainingSet.tsv

#create test set from never before seen plasmids
python pyScripts/createPlasmidSamplesWithMutation.py \
				plasmids/targetPlasmids.txt \
				controlPlasmids/TESTcontrolPlasmids.txt \
				10 \
				1000000 \
				0.05 \
				500 \
				16 > trainingData/plasmidTestSet.tsv

#train model and test on the test set
sbatch -e /dev/null -o output/PLASMID_TEST_RESULT shellScripts/runClassifierJob.sh trainingData/plasmidTrainingSet.tsv trainingData/plasmidTestSet.tsv
