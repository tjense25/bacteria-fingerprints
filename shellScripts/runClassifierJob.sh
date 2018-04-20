#!/bin/bash

#SBATCH --time=02:00:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32G   # memory per CPU core
#SBATCH -J "E Coli Training Data $1"   # job name
module load r/3/3

if [ $# -lt 2 ]
then
	Rscript --vanilla Rscripts/runClassifier.R $1 8
else
	Rscript --vanilla Rscripts/runClassifier.R $1 $2
fi
