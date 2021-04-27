#script to plot histogram of read counts for individuals

library(ggplot2)
library(scales)
options("scipen"=100, "digits"=4)

#SCRIPT TO PLOT HISTOGRAM OF READ COUNTS AND ALIGNMENTS

# setup arguments should be "Rscript --vanilla ${workingDataDirectory} ${pop}
args <- commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}
print(args)

setwd("args[1]")
stats <- read.csv(file = "STATS.all", header = FALSE)
colnames(stats) <- c("individual", "reads", "ppalign", "rmdup")


### READS ###
pdf(paste(args[2], "readCount.histo", sep="."), height=85, width=140)
ggplot(stats, aes(x=reads)) +
  geom_histogram(binwidth=10000, colour="black", fill="white") +
  theme(axis.text.x=element_text(angle=90,hjust=1)) +
  scale_x_continuous(name = "Read Count", breaks = seq(0, 18000000, by=1000000)) +
  scale_y_continuous(name = NULL, breaks = seq(0, 70, by=10))
dev.off()

pdf(paste(args[2], "readCount.0to2M.histo", sep="."), height=85, width=140)
ggplot(stats, aes(x=reads)) +
  geom_histogram(binwidth=10000, colour="black", fill="white") +
  theme(axis.text.x=element_text(angle=90,hjust=1)) +
  scale_x_continuous(name = "Read Count", limit = c(0, 2000000), breaks = seq(0, 2000000, by=100000)) +
  scale_y_continuous(name = NULL, breaks = seq(0, 70, by=10))
dev.off()

### RMDUP ###
pdf(paste(args[2], "alignCount.histo", sep="."), height=85, width=140)
ggplot(stats, aes(x=rmdup)) +
  geom_histogram(binwidth=10000, colour="black", fill="white") +
  theme(axis.text.x=element_text(angle=90,hjust=1)) +
  scale_x_continuous(name = "Read Count", breaks = seq(0, 18000000, by=1000000)) +
  scale_y_continuous(name = NULL, breaks = seq(0, 70, by=10))
dev.off()

pdf(paste(args[2], "alignCount.0to2M.histo", sep="."), height=85, width=140)
ggplot(stats, aes(x=rmdup)) +
  geom_histogram(binwidth=10000, colour="black", fill="white") +
  theme(axis.text.x=element_text(angle=90,hjust=1)) +
  scale_x_continuous(name = "Read Count", limit = c(0, 2000000), breaks = seq(0, 2000000, by=100000)) +
  scale_y_continuous(name = NULL, breaks = seq(0, 70, by=10))
dev.off()



