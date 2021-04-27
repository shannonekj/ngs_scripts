numbs<-seq(1:34073) # put number of loci here
rabo<-sprintf("R%06d", numbs)
write.table(rabo, quote=FALSE, col.names = FALSE, row.names = F)
