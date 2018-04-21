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
BPS <- read_delim(in_file, delim=" ", col_names=FALSE)
print(BPS)

name <- ""
bpsKmers <- data.frame(ind=1:286)
plot <- ggplot(bpsKmers, aes(x=ind))
for (i in 1:nrow(BPS)) {
	plot + geom_line(aes(y = BPS[i, 3:ncol(BPS)], colour = BPS[i, 1]))
	name <- paste0(name, BPS[i, 1])

}
plot + labs(colour = "Species") +
	xlab("Base Percentage Space 10-mers") +
	ylab("Probability of Sampling 10-mer") +
	theme_bw() +
	theme(text = element_text(size=16))

 
ggsave(plot, file=paste0("plots/",name, "Spectrum.jpeg"))
