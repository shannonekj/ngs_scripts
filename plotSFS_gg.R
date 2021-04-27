#!/usr/bin/Rscript

# Usage: Rscript -i infile.sfs -n number_of_individuals -o outfile.pdf

library(methods)
library(optparse)
library(ggplot2)

# colorblind friendly: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# To use for fills, add: scale_fill_manual(values=cbPalette)
# To use for line and point colors, add: scale_colour_manual(values=cbPalette)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (output from getMDS)'),
                    make_option(c('-n','--numInd'), action='store', type='character', default=NULL, help='Number of individuals used to create sfs file'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
                    )
opt <- parse_args(OptionParser(option_list = option_list))


## Create objects for options
sfs <- scan(opt$in_file, stringsAsFact=F)
nInd <- as.numeric(opt$numInd[[1]])
saveFile <- opt$out_file

#function to normalize
norm <- function(x) x/sum(x)

# the variable categories of the sfs
sfs<-norm(sfs[-c(1,length(sfs))])

# variability
pvar<- (1-sfs[1]-sfs[length(sfs)])*100

# plot
SFS <- as.data.frame(sfs)
SFS$name <- c(1:length(sfs))
p <- ggplot(data=SFS, aes(y=sfs, x=name)) + 
	geom_bar(stat="identity") +
	scale_x_continuous(breaks=seq(1, nrow(SFS), 2)) +
	scale_y_continuous(breaks=seq(0, 1, 0.05)) +
	labs(title=opt$in_file, y="Normalized Frequency", x="Number of polymorphisms")
ggsave(saveFile, plot=p, device="pdf")



