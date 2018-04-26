# bacteria-fingerprints
Using the base-percentage space spectrum of the 10-mer decomposition of genomic and plasmid DNA to classify bacteria strains


## Software Dependencies
#### INSTALL JELLYFISH
Our analysis requires the use of jellyfish to count the number of unique
k-mers in a genome sequence. Get the source code directly by by preforming a wget on the source code link
which can be found on their git repo <a href="https://github.com/gmarcais/Jellyfish">  here</a>.

User guide for the jellyfish software can be found <a href="http://www.genome.umd.edu/docs/JellyfishUserGuide.pdf"> here</a>.
Jelly fish software is developed by Guillaume Marçais or Carl Kingsfor.

#### INSTALL R Libraries

In order to run our analysis, the following R libraries need to be installed:

* tidyr
* readr
* dplyr
* mlr
* ggplot2

Download these packages using the R packages.install() command before running the analysis script

## Running Analysis Pipeline

Code for analysis is all automated and contained in the runModel shell script of 
the home directory of the repository. 
