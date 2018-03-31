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
fingerprints <- fingerprints[complete.cases(fingerprints), ]

#remove the toxicity column of matrix and store result as matrix 
characterMatrix <- as.matrix(select(fingerprints, -species))

#get principal components from the matrix and store it in an object
fingerprintPC <- prcomp(characterMatrix)

#extract actual principal components and plot the first two PCs
PCs <- as.data.frame(fingerprintPC$x)

ggplot(PCs, aes(x=PC1, y=PC2, colour=fingerprints$species)) +
	geom_point() +
	labs(colour = "species") + 
	ggtitle("Principal Component Analysis Plot") +
	theme_bw() + 
	theme(text = element_text(size=20),
	      plot.title = element_text(hjust = 0.5),
	      panel.border = element_blank(),
	      panel.grid.major = element_blank(),
	      axis.line = element_line(colour = "black"))


ggsave("PCA.jpeg")

#find out how much variance is explained by the first 10 principal components
#and make a graphic to describe this

percentVE <- 100 * fingerprintPC$sdev^2 / sum(fingerprintPC$sdev^2)

percentVEdf <- data.frame(PC=1:10, PercentExplained=percentVE[1:10])

ggplot(percentVEdf, aes(PC, PercentExplained, fill=PC)) +
	geom_bar(stat="identity") +
	xlab("Principal Component") +
	ylab("% Variance explained") +
	theme_bw() + 
	theme(text = element_text(size=20),
	      plot.title = element_text(hjust = 0.5),
	      panel.border = element_blank(),
	      panel.grid.major = element_blank(),
	      legend.position="none",
	      axis.line = element_line(colour = "black"))

ggsave("varainceExplainedPCA.pdf")
