#!/apps/r/3.3.0/bin/Rscript


#load necessary libraries
library(mlr)
library(magrittr)
library(dplyr)
library(readr)

#get input data from command line and read it into a data frame
args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}

#Read in pepseq data as a dataframe
in_file <- args[1]

#Read data into a dataframe
fingerprint <- read_tsv(in_file)

str(fingerprint)

#convert all characters into factors
fingerprint <- as.data.frame(unclass(fingerprint))


#create a task object to indicate which data will be used,
#and what is the target value for the classification
task <- makeClassifTask(data = fingerprint, target = "species")

#Create a learner with the random Forest algorithm
#specify we want the algorithm to generate probabilistic predictions
learner <- makeLearner("classif.randomForest", predict.type = "prob")

#specify resampling strategy, using crossvalidation with 10 folds
resampleDesc = makeResampleDesc("CV", iters = 10)

#set random seed, so it is computationally reproducible
set.seed(1)

#make predictions by combinidng the data with the algorithm with the resampling strategy
results <- resample(learner, task, resampleDesc, show.info=FALSE)

metrics <- performance(results$pred, measures=list(mlr::acc, tpr, tnr, ppv, f1, auc))

metrics

