#!/bin/bash

sbatch createTrainingData.sh ecoli+VIM-1
sbatch createTrainingData.sh ecoli+KPC-2
sbatch createTrainingData.sh ecoli+NDM-1 
sbatch createTrainingData.sh ecoli+IMP-4
