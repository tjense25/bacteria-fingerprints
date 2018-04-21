#!/apps/r/3.3.0/bin/Rscript

#install necessary libraries:
library(ggplot2)
library(ggthemes)
library(readr)
library(tidyr)
library(dplyr)

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}


in_file <- args[1]
BPS <- read_delim(in_file, delim=" ", col_names=FALSE)
names(BPS) <- c("name", "count", 1:286)

bias <- NULL
for (a in 0:10) {
	for (c in 0:11) {
		for (g in 0:11) {
			for (t in 0:11) {
				if ( a + c + g + t == 10) 
					bias <- c(bias, (factorial(10) / factorial(a) / factorial(c) / factorial(g) / factorial(t)) / 4^10)

			}
		}
	}
}

bias <- data.frame(BPSIndex = 1:286, BPSFreq = bias)

BPS <- select(BPS, -count)
BPS <- gather(BPS, "BPSIndex", "BPSFreq", 2:ncol(BPS))

BPS$BPSIndex <- as.integer(BPS$BPSIndex)
BPS$BPSFreq <- as.numeric(BPS$BPSFreq)
BPS$name <- as.factor(BPS$name)

plot <- ggplot(bias, aes(x=BPSIndex, y=BPSFreq)) +
	geom_line() +
	geom_point(data=BPS, aes(colour=name)) + 
	labs(colour="Species") + 
	xlab("Base Percentage Space 10-mers") +
	ylab("Probability of Sampling 10-mer") +
	theme_bw() +
	theme(text = element_text(size=16))

 
ggsave(plot, file = "plots/streptococcusSpectrum.jpeg")
