
library(readr)
library(ggplot2)
library(ggthemes)

speciesTestData <- read_tsv("output/speciesTestResult.out")

speciesPlot <- ggplot(speciesTestData, aes(numReads)) +
		geom_line(aes(y=Accuracy, colour="Accuracy")) +
		geom_line(aes(y=AUC, colour="AUC")) +
		scale_x_continuous("Model Performance", trans="log10", 
				   breaks = c(1,10,50,100,1000,10000,1000000),
				   labels = c(1,10,50,100,1000,10000,1000000)) +
		scale_y_continuous("Number of Optical Sequencing Reads", limits=c(0,1.0)) +
		theme_bw()

ggsave(speciesPlot, file="plots/speciesResultsPlot.jpeg")
