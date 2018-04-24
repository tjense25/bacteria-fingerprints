#!/bin/bash

#SBATCH --time=6:00:00   # walltime
#SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
module load python/2/7

k=10
if [ $# -ge 1 ] ; then
	k=$1
fi

#createPlasmidSamplesWithMutation.py \
# targetPlasmidBPSPath \
# controLPlasmidBPSpath \
# K-mer size \
# number_of_optical_sequencing_reads \
# mutation_rate \
# number_of_threads
python pyScripts/createPlasmidSamplesWithMutation.py \
				plasmids/targetPlasmids_$k.txt \
				controlPlasmids/controlPlasmidsBPS_$k.txt \
				$k \
				1000000 \
				0.05 \
				5000 \
				16 > trainingData/plasmidTrainingSet_$k.tsv

#run cross validation job on new plasmid training data
sbatch -e /dev/null -o output/PLASMID_CV_RESULT_$k shellScripts/runClassifierJob.sh trainingData/plasmidTrainingSet_$k.tsv

#create test set from never before seen plasmids
python pyScripts/createPlasmidSamplesWithMutation.py \
				plasmids/targetPlasmids_$k.txt \
				controlPlasmids/TESTcontrolPlasmidsBPS_$k.txt \
				$k \
				1000000 \
				0.05 \
				500 \
				16 > trainingData/plasmidTestSet_$k.tsv

#train model and test on the test set
sbatch -e /dev/null -o output/PLASMID_TEST_RESULT_$k shellScripts/runClassifierJob.sh trainingData/plasmidTrainingSet_$k.tsv trainingData/plasmidTestSet_$k.tsv
