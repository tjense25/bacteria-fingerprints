#!/bin/bash

#SBATCH --time=02:00:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
#SBATCH -J "E Coli Training Data $1"   # job name
module load r/3/3

INPUT=$1
Rscript --vanilla Rscripts/runClassifier.R $INPUT 8

