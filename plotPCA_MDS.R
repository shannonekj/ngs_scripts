#!/usr/bin/Rscript
# AUTHOR: Shannon E.K. Joslin
# DATE: 27 April 2021
# NOTE: Script to plot output of ANGSD PCA_MDS (single sampling method).
##      See: http://www.popgen.dk/angsd/index.php/PCA_MDS
# USAGE: Rscript -c <FILE>.covMat -b <BAMLIST> -o <OUTFILE_PREFIX>
##      * bamlist should be in the following format [ /path/to/R1 | /path/to/R2 | prefix ]
###             - where prefix is in the following form: Ht<indexNum>_<indNum>_<YYYY>_<well>


.libPaths("~/R/x86_64-pc-linux-gnu-library/3.4")
library(optparse)
library(ggplot2)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (output from -doCov 1)'),
                    make_option(c('-b','--bamlist'), action='store', type='character', default=NULL, help='bamlist of alned individuals FMT: [ /path/to/R1 | /path/to/R2 | prefix ]'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
                    )
opt <- parse_args(OptionParser(option_list = option_list))

# read files
covmat <- read.table(opt$in_file, stringsAsFact=F)
ind_list <- read.table(opt$bamlist, stringsAsFact=F)


# from ANGSD site
name <- "angsdput.covMat"
m <- as.matrix(read.table(name))
e <- eigen(m)
plot(e$vectors[,1:2],lwd=2,ylab="PC 2",xlab="PC 2",main="Principal components",col=rep(1:3,each=10),pch=16)
## heatmap / clustering / trees
name <- "angsdput.covMat" 
m <- as.matrix(read.table(name))
#heat map
heatmap(m)
#neighbour joining
plot(ape::nj(m))
plot(hclust(dist(m), "ave") 
