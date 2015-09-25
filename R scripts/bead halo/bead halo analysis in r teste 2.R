## Find out what file belongs to what tube:
WD <- getwd()
WD
beadhaloFL <- list.files(path=WD, recursive=TRUE, include.dirs=TRUE)
beadhaloFL <- as.data.frame(beadhaloFL)
beadhalotube <- data.frame(do.call('rbind', strsplit(as.character(beadhaloFL[,1]),'/',fixed=TRUE)))
beadhalotube <- subset(beadhalotube, grepl("200ms", X3)  &  !(grepl(".xml", X3)))
allfiles <- as.character(beadhalotube$X3)
allfiles <- paste0(allfiles, ".xml")

## Import all files
setwd("~/Lab Stuff 2014/Images/August/2014-08-14/teste junto/tabela2")
data <- lapply(allfiles,read.delim)

# Check number of beads per picture if we remove area under 10
numberbeads <- c()
for (i in 1:93) {
    numberbeads <- c(numberbeads, sum(data[[i]]$Area > 10))
}
hist(numberbeads, breaks=32)

# Remove rows with Area under 10.
for (i in 1:93) {
    data[[i]] <- subset(data[[i]], data[[i]]$Area >10)
}

# Take average and standard dev of mean fluorescence intensities

avgfluor <- c()
stdevfluor <- c()
for (i in 1:93) {
    avgfluor <- c(avgfluor, mean(data[[i]]$Mean))
    stdevfluor <- c(stdevfluor, sd(data[[i]]$Mean))
}

tabledata <- cbind(substr(allfiles, 1, nchar(allfiles)-4), numberbeads, avgfluor, stdevfluor)
beadhalodata <- merge(x=beadhalotube, y=tabledata, by.x="X3", by.y="V1")
names(beadhalodata) <- c("picture", "tube", "condition", "number.beads", "mean.fluor","std.fluor")
write.csv(beadhalodata, "beadhalodata.csv")

beadhalodata[,4] <- as.character(beadhalodata[,4])
beadhalodata[,5] <- as.character(beadhalodata[,5])
beadhalodata[,6] <- as.character(beadhalodata[,6])
beadhalodata[,4] <- as.numeric(beadhalodata[,4])
beadhalodata[,5] <- as.numeric(beadhalodata[,5])
beadhalodata[,6] <- as.numeric(beadhalodata[,6])

tube.lists <- read.csv("~/Lab Stuff 2014/Images/August/2014-08-14/tube lists.csv")
beadhalodata2 <- merge(x=beadhalodata, y=tube.lists, by="tube")
write.csv(beadhalodata2, "beadhalodata2.csv")

par(mfrow=c(1,2))
boxplot(beadhalodata2$mean.fluor[beadhalodata2$condition=="no wash" & beadhalodata2$ab.bead=="DHX9"] ~ beadhalodata2$tube[beadhalodata2$condition=="no wash" & beadhalodata2$ab.bead=="DHX9"], las=2, cex.axis=0.7)
boxplot(beadhalodata2$mean.fluor[beadhalodata2$condition=="washed" & beadhalodata2$ab.bead=="DHX9"] ~ beadhalodata2$tube[beadhalodata2$condition=="washed" & beadhalodata2$ab.bead=="DHX9"], las=2, cex.axis=0.7)

washedDHX9bead <- beadhalodata2[beadhalodata2$condition=="washed" & beadhalodata2$ab.bead=="DHX9",]
washedDHX9beadag <- aggregate(x=washedDHX9bead[,4:6], by=washedDHX9bead[,7:13], FUN=mean)
washedDHX9beadsd <- aggregate(x=washedDHX9bead[,4:6], by=washedDHX9bead[,7:13], FUN=sd)

fit <- aov(mean.fluor ~ tube, data=washedDHX9bead)
TukeyHSD(fit)