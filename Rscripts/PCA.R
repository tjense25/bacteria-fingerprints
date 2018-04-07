#!/apps/r/3.3.0/bin/Rscript

#install necesary libraryies
library(ggplot2)
library(ggthemes)
library(readr)
library(stringr)
library(dplyr)
library(doParallel)
library(foreach)

#Code to run Principal component analysis on data, view the multi dimensional
#data in less dimensions

args = commandArgs(trailingOnly=TRUE)



if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}
in_file <- args[1]

numCores = 1
if (length(args == 2)) {
	numCores <- as.integer(args[2])
} 

fingerprints <- read_tsv(in_file)
print(fingerprints)
fingerprints <- fingerprints[complete.cases(fingerprints), ]

registerDoParallel(cores = numCores)

bpsList <- list()
for (fileName in list.files(path="/fslgroup/fslg_genome/bacteria-fingerprints/bps", pattern="[^[:digit:]].bps$"))  {
	filePath <- paste0("/fslgroup/fslg_genome/bacteria-fingerprints/bps/",fileName)
	speciesName <- str_replace(fileName, ".bps", "")
	bps = read_tsv(filePath, col_names=FALSE)
	bpsList[[speciesName]] <- bps[[2]]
}

print(bpsList)

plasmidBPS <- matrix(nrow = 0, ncol = 286)
for ( i in 1:nrow(fingerprints)) {
	species <- as.character(fingerprints[i,"species"])
	vectorBPS <- as.numeric(fingerprints[i,1:286]) - bpsList[[species]]
	plasmidBPS <- rbind(plasmidBPS, vectorBPS)
}

plasmidPC <- prcomp(plasmidBPS)

percentVE <- 100 * plasmidPC$sdev^2 / sum(plasmidPC$sdev^2)

PCs <- as.data.frame(plasmidPC$x)

ggplot(PCs, aes(x=PC1, y=PC2, colour=fingerprints$plasmid)) +
	geom_point() +
	labs(colour = "plasmid") + 
	ggtitle("Plasmid BPS Clusters") +
	xlab(paste0("PC1 (", sprintf(percentVE[1], fmt="%#.4g"),"%)")) +
	ylab(paste0("PC2 (", sprintf(percentVE[2], fmt="%#.4g"),"%)")) + 
	theme_bw() + 
	theme(text = element_text(size=20),
	      plot.title = element_text(hjust = 0.5),
	      panel.border = element_blank(),
	      panel.grid.major = element_blank(),
	      axis.line = element_line(colour = "black"))


ggsave("plasmidPCA.jpeg", width = 10, height = 10, units = "in")

'''
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
	xlab(paste0("PC1 (", sprintf(percentVE[1], fmt="%#.4g"),"%)")) +
	ylab(paste0("PC2 (", sprintf(percentVE[2], fmt="%#.4g"),"%)")) + 
	theme_bw() + 
	theme(text = element_text(size=20),
	      plot.title = element_text(hjust = 0.5),
	      panel.border = element_blank(),
	      panel.grid.major = element_blank(),
	      axis.line = element_line(colour = "black"))


#ggsave("PCA.jpeg", width = 10, height = 10, units = "in")
'''



