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


mutate <- function(geneName, Spectrum) {
	print(geneName)
	gene <- Spectrum[which(Spectrum[[3]] == geneName), ]
	gene[["Frequency"]] <- gene[[2]] / max(gene[[2]]) 
	return(gene)
}

geneList <- c("IMP-4", "VIM-1", "NDM-1", "KPC-2")

geneDfList <- lapply(geneList, function(x) { return(mutate(x, BPSpaceCounts)) } )

combinedSpectrum <- geneDfList[[1]]
for (i in 2:length(geneDfList)) {
	combinedSepctrum <- rbind(combinedSpectrum, geneDfList[[i]])
}




ggplot(combinedSpectrum, aes(BasePercentageIndex, Frequency, colour=Gene)) +
	geom_point()

ggsave("resistanceGenesSpectrum.jpg")
