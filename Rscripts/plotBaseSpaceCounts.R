#!/apps/r/3.3.0/bin/Rscript

#install necessary libraries:
library(ggplot2)
library(ggthemes)
library(readr)

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}

in_file <- args[1]
BPSpaceCounts <- read_tsv(in_file)

ggplot(BPSpaceCounts, aes(BasePercentageIndex, Count, colour=Gene)) +
	geom_point()

ggsave("resistanceGenesSpectrum.jpg")
