# ANOVA and Tukey for qPCR data
qPCR <- read.csv("stats.csv")
qPCR <- qPCR[1:9,]

pvals <- vector("list",26)
tuknames <- list(c("NUP98-CO", "RHA-CO", "NUP98-DHX9"), c("nada"))
tukresult <- matrix(data = NA, nrow = 3, ncol = 1, byrow = FALSE, dimnames = tuknames)

for (i in 2:26) {
  fitanova <- aov(qPCR[,i] ~ qPCR[,1], data=qPCR)
  pvals[[i]][[1]] <- colnames(qPCR)[i]
  pvals[[i]][[2]] <- summary(fitanova)[[1]][["Pr(>F)"]][1]
  tukfit <- TukeyHSD(fitanova)
  tukresult <- cbind(tukresult, tukfit$`qPCR[, 1]`)
}

df <- data.frame(matrix(unlist(pvals), nrow=25, byrow=T),stringsAsFactors=FALSE)
write.csv(df, "pvals.csv")
write.csv(tukresult, "tukeyresults.csv")

# ANOVA and Tukey for RIP-qPCR data
setwd("~/Lab Stuff 2015 2nd sem/Experiments/qPCR RNA-IPs results")
RIP <- read.csv("~/Lab Stuff 2015 2nd sem/Experiments/qPCR RNA-IPs results/for stats r.csv")

fitanova <- aov(RIP[,2] ~ RIP[,1], data=RIP)
summary(fitanova)
tukfit <- TukeyHSD(fitanova)

pvals <- vector("list",6)
tuknames <- list(rownames(tukfit$`RIP[, 1]`), c("nada"))
tukresult <- matrix(data = NA, nrow = 15, ncol = 1, byrow = FALSE, dimnames = tuknames)

for (i in 2:6) {
  fitanova <- aov(RIP[,i] ~ RIP[,1], data=RIP)
  pvals[[i]][[1]] <- colnames(RIP)[i]
  pvals[[i]][[2]] <- summary(fitanova)[[1]][["Pr(>F)"]][1]
  tukfit <- TukeyHSD(fitanova)
  tukresult <- cbind(tukresult, tukfit$`RIP[, 1]`)
}

df <- data.frame(matrix(unlist(pvals), nrow=11, byrow=T),stringsAsFactors=FALSE)
write.csv(df, "pvals.csv")
write.csv(tukresult, "tukeyresults.csv")