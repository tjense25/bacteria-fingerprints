#!/bin/bash

#SBATCH --time=00:10:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=400M   # memory per CPU core
#SBATCH -J "E Coli Training Data $1"   # job name

# Compatibility variables for PBS. Delete if not needed.

NAME=$1

cat $NAME.bps | ./pyScripts/createSimulationSets.py $NAME 8 >> trainingsample.$1
