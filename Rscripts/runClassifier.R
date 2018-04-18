#!/apps/r/3.3.0/bin/Rscript


#load necessary libraries
library(mlr)
library(magrittr)
library(dplyr)
library(readr)
library("parallelMap")

#get input data from command line and read it into a data frame
args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}

#Read in pepseq data as a dataframe
in_file <- args[1]

cores <- 1
if (length(args) == 2) {
	cores <- as.integer(args[2])
}

parallelStartSocket(cores)



#Read data into a dataframe
fingerprint <- read_tsv(in_file)

#str(fingerprint)

#convert all characters into factors
fingerprint <- as.data.frame(unclass(fingerprint))

task <- makeClassifTask(data = fingerprint, target = "label")
learner <- makeLearner("classif.randomForest", predict.type = "prob")
resampleDesc = makeResampleDesc("CV", iters = 8)

#set random seed for computational reproducibility
set.seed(1)

#make predictions by combinidng the data with the algorithm with the resampling strategy
results <- resample(learner, task, resampleDesc, show.info=FALSE)

parallelStop()

save(results, file="results.Rdata")

metrics <- performance(results$pred, measures=[mlr::acc,mlr::multiclass.au1p,mlr::tnr,mlr::tpr])

print(metrics)

