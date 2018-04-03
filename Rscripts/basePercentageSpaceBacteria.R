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
BPSpaceCounts <- as.data.frame(read_tsv(in_file))


mutate <- function(name, Spectrum) {
	print(name)
	gene <- Spectrum[which(Spectrum[[3]] == name), ]
	gene[["Frequency"]] <- gene[[2]] / sum(gene[[2]]) 
	return(gene)
}

nameList <- c("ecoli", "ypestis")

combinedSpectrum <- lapply(nameList, function(x) { return(mutate(x, BPSpaceCounts)) } )

combinedSpectrum <- rbind(combinedSpectrum[[1]], combinedSpectrum[[2]])

ggplot(combinedSpectrum, aes(BasePercentageIndex, DeviationFromNormal, colour=Name)) +
	geom_point()

ggsave("speciesDeviationFromNormalSpectrum.jpg")
