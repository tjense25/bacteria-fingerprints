#!/apps/r/3.3.0/bin/Rscript


#load necessary libraries
library(mlr)
library(magrittr)
library(dplyr)
library(readr)
library("parallelMap")

check.integer <- function(N) {
	!grepl("[^[:digit:]]", format(N))
}

#get input data from command line and read it into a data frame
args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
	stop("ERROR: Must specify input file as argument", call.=FALSE)
}

#Read in pepseq data as a dataframe
in_file <- args[1]
crossValidate <- TRUE

#Read data into a dataframe
fingerprint <- read_tsv(in_file)

cores <- 1
if (length(args) >= 2) {

	if(check.integer(args[2])) {
		cores <- as.integer(args[2])
	} else {
		TEST_file <- args[2]
		TEST <- read_tsv(TEST_file)
		TestIndex <- nrow(fingerprint) + 1
		fingerprint <- rbind(fingerprint, TEST)
		train.set <- 1:TestIndex
		test.set <- TestIndex:nrow(fingerprint)
		crossValidate <- FALSE
	}
}



#str(fingerprint)

#convert all characters into factors
fingerprint <- as.data.frame(unclass(fingerprint))

task <- makeClassifTask(data = fingerprint, target = "label")
learner <- makeLearner("classif.randomForest", predict.type = "prob")

if (crossValidate) {
#set random seed for computational reproducibility
	parallelStartSocket(cores)
	set.seed(1)

	resampleDesc = makeResampleDesc("CV", iters = 10)
	#make predictions by combinidng the data with the algorithm with the resampling strategy
	results <- resample(learner, task, resampleDesc, show.info=FALSE)
	parallelStop()
	save(results, file="results.Rdata")
	preds <- results$pred
} else {
	model = train(learner, task, subset = train.set)
	preds <- predict(model, task = task, subset = test.set)
}

metrics <- performance(preds, measure=list(mlr::acc,mlr::multiclass.au1p))

print(metrics)
