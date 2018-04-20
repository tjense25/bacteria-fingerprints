
library(readr)
library(ggplot2)
library(ggthemes)

speciesTestData <- read_tsv("output/speciesTestResult.out")

speciesPlot <- ggplot(speciesTestData, aes(numReads)) +
		geom_line(aes(y=Accuracy, colour="Accuracy", size=1.5)) +
		geom_line(aes(y=AUC, colour="AUC", size=1.5)) +
		scale_x_continuous("Number of Optical Sequencing Reads", trans="log10", 
				   breaks = c(1,10,100,1000,10000,1000000),
				   labels = c(1,10,100,1000,10000,1000000)) +
		scale_y_continuous("Model Performance", limits=c(0,1.0)) +
		theme_bw() +
		theme(text = element_text(size=20))

ggsave(speciesPlot, file="plots/speciesResultsPlot.jpeg")
