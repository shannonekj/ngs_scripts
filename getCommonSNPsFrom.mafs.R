#!/usr/bin/Rscript
# Usage: Rscript -p prefix${year}* -s *${year}suffix -w working/directory -n number_of_individuals -o outfile.eps

# Options that I need
#	All mafs files
#	working directory
#	number of individuals cutoff
# 	suffix for Ht_${year}_${suffix}.mafs files

.libPaths("~/R/x86_64-pc-linux-gnu-library/3.4")

library(optparse)
library(tidyverse)
library(reshape2)

option_list <- list(make_option(c('-p', '--prefix'), action='store', type='character', default=NULL, help='Everything that comes before the year in mafs files (output from -doMaf in ANGSD)'),
		    make_option(c('-s', '--suffix'), action='store', type='charater', default=NULL, help='Everything that comes after the year in the mafs files (output from -doMaf in ANGSD)'),
		    make_option(c('-w', '--workDir'), action='store', type='character', default=NULL, help='Pretty simple, this is the working directory to use'),
		    make_option(c('-n', '--numInd'), action='store', type='numerical', default=NULL, help='Cutoff for the number of individuals you would like each SNP to have (usually 0.5 of the number of total ind'),
		    make_option(c('-o', '--outFile'), action='store', type='character', default='out.txt', help='Output file name')
                    )
opt <- parse_args(OptionParser(option_list = option_list))

prefix <- read.table(opt$prefix, stringsAsFact=F)
suffix <- read.table(opt$suffix, stringsAsFact=F)
workDir <- read.table(opt$workDir, stringsAsFact=F)
numInd <- as.numeric(opt$numInd[[1]])
outfile <- read.table(opt$outFile, stringsAsFact=F)


# read in data for each year & combine chromosome and position number for comparison
mafs_files <- list.files(path=".", pattern='Ht.*\\.mafs.gz', full.names=TRUE)
mafs_col <- c('chromo',	'position', 'major', 'minor', 'freq', 'puEM', 'nInd')
mafs_raw <- tibble(file=mafs_files) %>% 
	mutate(data=map(file, read_tsv, col_names=mafs_col, skip=1)) %>%
	mutate(basename=basename(file))  %>%
	extract(basename, into='year', 'Ht_(.*)\\_callGeno.mafs.gz', convert=TRUE) %>%
	unnest(data) 

# first take out years with not enough individuals (n<20)
mafs <- mafs_raw %>% filter(nInd>=20)


# filter SNPs by how many years have NA for MAF estimation
df <- mafs %>% select(-file, -major, -minor, -nInd, -puEM) 
dfreq <- df %>% spread(year, freq)
dfreq$na_count <- apply(is.na(dfreq), 1, sum)
ggplot(dfreq, aes(x=na_count)) +
  geom_histogram(breaks=seq(0, as.numeric(ncol(dfreq)-3), by=1), color="black", fill="light grey") +
  labs(title="Histogram of NAs for all SNPs w/nInd >= 20 for each year", x="NA Count", y="Frequency") +
  scale_y_continuous(label=scales::comma)
ggsave("PLOT_Histogram_NAcountBySNP.allSNP.nInd20.pdf", plot=last_plot())

dfreq_filt <- dfreq %>% filter(na_count==0)
yearNAs <- as.data.frame(sapply(dfreq_filt[ ,3:as.numeric(ncol(dfreq_filt)-1)], function(x) sum(length(which(is.na(x))))))
yearNAs$year <- rownames(yearNAs)
yearNAs <- rename(yearNAs, "num_NA"="sapply(dfreq_filt[, 3:as.numeric(ncol(dfreq_filt) - 1)], function(x) sum(length(which(is.na(x)))))")
ggplot(yearNAs, aes(y=num_NA, x=year)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title="Histogram of the number of NAs per year for final SNP set", y="Total NA Count", x="Year")
ggsave("PLOT_Histogram_NAcountByYear.nInd20.pdf", plot=last_plot())



# save table of the loci for input into ANGSD
write.table(dfreq_filt[,1:2], file="DS_history_lociForNe.nInd20.noNA.fromCalledGenos.txt", sep=":", quote=FALSE, row.names=FALSE, col.names=FALSE)
