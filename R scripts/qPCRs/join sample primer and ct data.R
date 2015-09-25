library(xlsx)

# Create standard plate numbering
Z <- t(array(1:12, dim=c(12,8))); 
X <- array(c("A","B","C","D","E","F","G","H"), dim=c(8,12)); 
Y <- paste(X, Z, sep="");
IDs <- array(Y, c(8,12)) # Writes 12 Ax-Hx columns into one.
IDs <- array(t(IDs),c(96,1))

# Import plates and make list with Ct values
rowname <- letters[1:8]
colname <- as.character(1:12)

plates <- list.files("~/Lab Stuff 2015 2nd sem/Experiments/qPCR HeLa 293T KD results/plates for R/samples/")
qPCRs <- list.files("~/Lab Stuff 2015 2nd sem/Experiments/qPCR HeLa 293T KD results/plates for R/qPCRs/")
tableqPCR <- matrix(data = NA, nrow = 96, ncol = 1, byrow = FALSE, dimnames = NULL)
tableqPCR[,1] <- IDs
for (i in c(1:10)) {
  samples <- read.csv(paste0("~/Lab Stuff 2015 2nd sem/Experiments/qPCR HeLa 293T KD results/plates for R/samples/", plates[i]), header=FALSE, stringsAsFactors=FALSE, row.names = rowname, col.names = colname, nrows = 8)
  primers <- read.csv(paste0("~/Lab Stuff 2015 2nd sem/Experiments/qPCR HeLa 293T KD results/plates for R/samples/", plates[i]), header=FALSE, stringsAsFactors=FALSE, row.names = rowname, col.names = colname, skip = 9, nrows = 8)
  samples <- as.array(as.matrix(samples))
  primers <- as.array(as.matrix(primers))
  samples <- array(t(samples), c(96,1))
  primers <- array(t(primers), c(96,1))
  Cts <- read.xlsx(paste0("~/Lab Stuff 2015 2nd sem/Experiments/qPCR HeLa 293T KD results/plates for R/qPCRs/", qPCRs[i]), 1)
  colnames(Cts) <- c("well","type","threshold","Cq")
  Cts <- Cts[Cts$Cq != "Reference", c(1,4)]
  Cts$Cq <- as.character(Cts$Cq)
  tableqPCR <- cbind(tableqPCR, samples, primers, Cts)
}

tableqPCR <- tableqPCR[,colnames(tableqPCR) != "well"]
tableqPCR <- tableqPCR[,colnames(tableqPCR) != "tableqPCR"]

write.csv(tableqPCR, "tableqPCRs.csv")
