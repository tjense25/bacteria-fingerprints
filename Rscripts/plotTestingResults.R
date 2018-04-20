
library(readr)
library(ggplot2)
library(ggthemes)

speciesTestData <- read_tsv("output/speciesTestResult.out")
mutationTestData <- read_tsv("output/randomMutationTest.out")
print(mutationTestData)

speciesPlot <- ggplot(speciesTestData, aes(numReads)) +
		geom_line(aes(y=Accuracy, colour="Accuracy")) +
		geom_line(aes(y=AUC, colour="AUC")) +
		labs(colour = "Performance Metric") + 
		scale_x_continuous("Number of Optical Sequencing Reads", trans="log10", 
				   breaks = c(1,10,100,1000,10000,1000000),
				   labels = c(1,10,100,1000,10000,1000000)) +
		scale_y_continuous("Model Performance", limits=c(0,1.0)) +
		theme_bw() +
		theme(text = element_text(size=16), legend.position="none")


mutationPlot <- ggplot(mutationTestData, aes(mutRate)) +
		geom_line(aes(y=Accuracy, colour="Accuracy")) +
		geom_line(aes(y=AUC, colour="AUC")) +
		labs(colour = "Performance Metric") + 
		scale_x_continuous("Mutation Rate", limits=c(0,1.0)) +
		scale_y_continuous("Model Performance", limits=c(0,1.0)) +
		theme_bw() +
		theme(text = element_text(size=16))

require(gridExtra)
combined <- grid.arrange(speciesPlot, mutationPlot, ncol=2)
ggsave(speciesPlot, file="plots/speciesResultsPlot.jpeg")
