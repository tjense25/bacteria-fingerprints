#!/apps/r/3.3.0/bin/Rscript

#install necesary libraryies
library(ggplot2)
library(ggthemes)
library(readr)
library(dplyr)

#Code to run Principal component analysis on data, view the multi dimensional
#data in less dimensions

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}

in_file <- args[1]
fingerprints <- read_tsv(in_file)
print(fingerprints)
fingerprints <- fingerprints[complete.cases(fingerprints), ]

#remove the toxicity column of matrix and store result as matrix 
characterMatrix <- as.matrix(select(fingerprints, -species, -plasmid))

#get principal components from the matrix and store it in an object
fingerprintPC <- prcomp(characterMatrix)


#find out how much variance is explained by each principal component
percentVE <- 100 * fingerprintPC$sdev^2 / sum(fingerprintPC$sdev^2)

#extract actual principal components and plot the first two PCs
PCs <- as.data.frame(fingerprintPC$x)

ggplot(PCs, aes(x=PC1, y=PC2, colour=fingerprints$species)) +
	geom_point() +
	labs(colour = "species") + 
	ggtitle("Principal Component Analysis Plot") +
	xlab(paste0("PC1 (", percentVE[1],"%)")) +
	ylab(paste0("PC2 (", percentVE[2],"%)")) + 
	theme_bw() + 
	theme(text = element_text(size=20),
	      plot.title = element_text(hjust = 0.5),
	      panel.border = element_blank(),
	      panel.grid.major = element_blank(),
	      axis.line = element_line(colour = "black"))


ggsave("PCA.jpeg", width = 10, height = 10, units = "in")

