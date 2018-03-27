#!/bin/bash

#SBATCH --time=00:01:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=512M   # memory per CPU core
#SBATCH -J "E Coli Training Data $1"   # job name

cat slurm* >> combinedTrainingSample.tsv
rm -f slurm*
rm -rf temp

