#!/bin/bash

#SBATCH --time=00:10:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=400M   # memory per CPU core

SPECIES=$1
PLASMID=$2


if [ ! "$PLASMID" == "None" ]
then
	cat temp/$SPECIES.10mers temp/*$PLASMID.10mers | pyScripts/convertToBasePercentageSpace.py 10 $SPECIES+$PLASMID > bps/$SPECIES+$PLASMID.bps 
	cat bps/$SPECIES+$PLASMID.bps | pyScripts/createSimulationSets.py $SPECIES+$PLASMID 8
else
	cat temp/$SPECIES.10mers | pyScripts/convertToBasePercentageSpace.py 10 $SPECIES > bps/$SPECIES.bps
	cat bps/$SPECIES.bps | pyScripts/createSimulationSets.py $SPECIES+$PLASMID 8
fi
