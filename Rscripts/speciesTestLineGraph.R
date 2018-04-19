#!/apps/r/3.3.0/bin/Rscript

library(ggplot2)
library(ggthemes)
library(readr)

'''dataSamples <- data.frame(Metric=rep(1 5 10 50 100 1000 10000 100000),
Accuracy=rep(0.1630000 0.2854444 0.4828889 0.6271111 0.9665556 0.9975556 1 1),
AUC=rep(0.6096764 0.7807460 0.8947594 0.9370655 0.9980954 0.9999885 1 1)'''

dataSamples <- read_tsv(file = "../output/results.txt")
x = c(1, 5, 10, 50, 100, 1000, 10000)

ggplot(dataSamples, aes(y = dataSamples[1, 2:], x))
	+ geom_line(aes(color=dataSamples[1, 2:]))


ggsave("SpeciesTestResults")
