
fin <- commandArgs(T)
fout <- paste(fin,".pdf",sep="",collaps="")

library(ape)
library(phangorn)

pdf(file=fout)

plot(read.tree(fin), cex=0.5)

invisible(dev.off())


