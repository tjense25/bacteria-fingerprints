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

BPS <- select(BPS, -count)
BPS <- gather(BPS, "BPSIndex", "BPSFreq", 2:ncol(BPS))

BPS$BPSIndex <- as.integer(BPS$BPSIndex)
BPS$BPSFreq <- as.numeric(BPS$BPSFreq)
BPS$name <- as.factor(BPS$name)

bias <- NULL
for (a in 0:10) {
	for (c in 0:10) {
		for (g in 0:10) {
			for (t in 0:10) {
				if ( a + c + g + t == 10) 
					bias <- c(bias, (factorial(10) / factorial(a) / factorial(c) / factorial(g) / factorial(t)) / 4^10)

			}
		}
	}
}

normalizedBPS <- cbind(BPS)

for (i in 1:nrow(BPS)) {
	normalizedBPS[i,"BPSFreq"] = BPS[i,"BPSFreq"] - bias[ as.integer(BPS[i,"BPSIndex"])]
}


bias <- data.frame(BPSIndex = 1:286, BPSFreq = bias)

plot1 <- ggplot(bias, aes(x=BPSIndex, y=BPSFreq)) +
	geom_line(alpha=0.5) +
	geom_point(data=BPS, aes(colour=name)) + 
	labs(colour="Species") + 
	scale_x_continuous("Base Percentage Space 10-mers", limits=c(0,286)) +
	scale_y_continuous("10-mer Frequency") +
	theme_bw() +
	theme(text = element_text(size=16))

ggsave(plot = plot1, file = "plots/streptococcusSpectrum.jpeg")

plot2 <- ggplot(normalizedBPS, aes(x=BPSIndex, y=BPSFreq, colour=name)) +
	 geom_point() +
	 labs(colour="Species") + 
	 scale_x_continuous("Base Percentage Space 10-mers", limits=c(0,286)) +
	 scale_y_continuous("Deviation from Normal") +
	 theme_bw() +
	 theme(text = element_text(size=16))

ggsave(plot = plot2, file = "plots/streptococcusDeviationFromNormal.jpeg")
	 



