## Find out what file belongs to what tube:
WD <- getwd()
beadhaloFL <- list.files(path=WD, recursive=TRUE, include.dirs=TRUE)
beadhaloFL <- as.data.frame(beadhaloFL)
beadhalotube <- data.frame(do.call('rbind', strsplit(as.character(beadhaloFL[,1]),'/',fixed=TRUE)))
beadhalotube <- subset(beadhalotube, grepl("200ms", X3)  &  !(grepl(".xml", X3)))
nowashfiles <- as.character(beadhalotube$X3[beadhalotube$X2 == "no wash"])
washedfiles <- as.character(beadhalotube$X3[beadhalotube$X2 == "washed"])
nowashfiles <- paste0(nowashfiles, ".xml")
washedfiles <- paste0(washedfiles, ".xml")

## Import all nowash files
setwd("~/Lab Stuff 2014/Images/August/2014-08-14/teste junto/tabela2")
nowash <- lapply(nowashfiles,read.delim)

# Check if we can remove area under 10
numberbeads <- c()
for (i in 1:42) {
    numberbeads <- c(numberbeads, sum(nowash[[i]]$Area > 10))
}

# Remove rows with Area under 10.
for (i in 1:42) {
    nowash[[i]] <- subset(nowash[[i]], nowash[[i]]$Area >10)
}

# Take average and standard dev of mean fluorescence intensities

avgfluor <- c()
stdevfluor <- c()
for (i in 1:42) {
    avgfluor <- c(avgfluor, mean(nowash[[i]]$Mean))
    stdevfluor <- c(stdevfluor, sd(nowash[[i]]$Mean))
}

nowashdata <- cbind(substr(nowashfiles, 1, nchar(nowashfiles)-4), avgfluor, stdevfluor)
