#!/bin/bash
set -e

k=10 #defualt kmer size is 10 if not specified
if [ $# -ge 1 ] ; then
	k=$1
fi
echo "Running model with k = $k" >&2


#######---CONVERT SPECIES REFERENCE SEQUENCE INTO BPS---#########
echo "Converting species reference sequences into Base-percentage Space" >&2 
./shellScripts/createSpeciesBPS.sh $k > bacteria/combinedSpeciesBPS_$k.txt

######--CONVERT ANTIBIOTIC RESISTANCE GENES INTO BPS---#########
echo "Converting resistance plasmid reference sequences into Base-percentage Space" >&2 
./shellScripts/createPlasmidBPS.sh $k > plasmids/targetPlasmids_$k.txt

#####--CONVERT TARGET PLASMIDS INTO BPS--##########
echo "Converting control plasmid reference sequences into Base-percentage Space" >&2 
./shellScripts/createControlBPS.sh $k > controlPlasmids/controlPlasmidsBPS.txt

#Split the control plasmids into a training and a test set
tail -n 100 controlPlasmids/controlPlasmidsBPS.txt >  controlPlasmids/TESTcontrolPlasmidsBPS_$k.txt
head -n 900 controlPlasmids/controlPlasmidsBPS.txt > controlPlasmids/controlPlasmidsBPS_$k.txt
rm controlPlasmids/controlPlasmidsBPS.txt

####--SUBMIT JOB TO CREATE SPECIES TRAINING SAMPLES AND RUN MLA--########
echo "Submitting Species MLA job" >&2 
sbatch shellScripts/runSpeciesMLA.sh $k


####--SUBMIT JOB TO CREATE PLASMID TRAINING SAMPLES AND RUN PLASMID MLA--######
echo "Submitting Plasmid MLA job" >&2 
sbatch shellScripts/runPlasmidMLA.sh $k

exit 0
