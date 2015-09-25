setwd("~/Lab Stuff 2015 2nd sem/Images/Jul16_15/vRNA FISH/deconv for RF")
results <- read.csv("~/Lab Stuff 2015 2nd sem/Images/Jul16_15/vRNA FISH/deconv for RF/results Cell and Nuclei2.csv")
summary(results)
str(results)
results1to4k <- results[ which(cy3_tt > 1000 & cy3_tt < 4000),]

Ag1to4kmean <- aggregate(results1to4k[,2:7], list(results1to4k$drug), mean)
Ag1to4sd <- aggregate(results1to4k[,2:7], list(results1to4k$drug), sd)
Agsd <- aggregate(results[,2:7], list(results$drug), sd)
Agmean <- aggregate(results[,2:7], list(results$drug), mean)
