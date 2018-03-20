#!/bin/bash

#SBATCH --time=00:10:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=400M   # memory per CPU core
#SBATCH -J "E Coli Training Data $1"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

NAME=$1

cat $1.bps | ./pyScripts/createSimulationSets.py $1 8 >> trainingsample.$1
