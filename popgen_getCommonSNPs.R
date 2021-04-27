#!/usr/bin/Rscript
# Usage: Rscript -i basenameOfInfile.mafs.gz -m minInd -w workingDirectory -o out.file
# this script should be used to gather the common SNPs for estimating contemporary Ne

.libPaths("~/R/x86_64-pc-linux-gnu-library/3.4")

#install.packages(c('tidyverse', 'reshape2', 'optparse')
library(optparse)
library(tidyverse)
library(reshape2)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='This is the base name of the geno files you want to input)'),
                    make_option(c('-m','--minInd'), action='store', type='character', default=15, help='MinInd or half of the number of individuals in your files'),
                    make_option(c('-w','--working_dir'), action='store', type='character', default=NULL, help='Global path to working directory (use quotes)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
                    )
opt <- parse_args(OptionParser(option_list = option_list))
base <- opt$in_file
base
min_ind <- as.numeric(opt$minInd)
min_ind
work_dir <- opt$working_dir
outFile <- opt$out_file

setwd(work_dir)

mafs_files <- list.files(path=".", pattern=paste('.*\\', base, sep=""))


______STOPPED_HERE_______




# read in data for each year & combine chromosome and position number for comparison
mafs_files <- list.files(path=".", pattern='Ht.*\\.mafs.gz', full.names=TRUE)
mafs_col <- c('chromo',	'position',	'major', 'minor',	'freq',	'puEM',	'nInd')
mafs_raw <- tibble(file=mafs_files) %>% 
  mutate(data=map(file, read_tsv, col_names=mafs_col, skip=1)) %>%
  mutate(basename=basename(file))  %>%
  extract(basename, into='year', 'Ht_(.*)\\_callGeno.mafs.gz', convert=TRUE) %>%
  unnest(data) 

# first take out SNPs that with not enough individuals (n<15)
mafs <- mafs_raw %>% filter(nInd>=15)


# filter SNPs by how many years have NA for MAF estimation
df <- mafs %>% select(-file, -major, -minor, -nInd, -puEM) 
dfreq <- df %>% spread(year, freq)
dfreq$na_count <- apply(is.na(dfreq), 1, sum)
ggplot(dfreq, aes(x=na_count)) +
  geom_histogram(breaks=seq(0, as.numeric(ncol(dfreq)-3), by=1), color="black", fill="light grey") +
  labs(title="Histogram of NAs for all SNPs w/nInd >= 20 for each year", x="NA Count", y="Frequency") +
  scale_y_continuous(label=scales::comma)
ggsave("PLOT_Histogram_NAcountBySNP.allSNP.nInd15.pdf", plot=last_plot())

# eliminate any SNP that has an NA
dfreq_filt <- dfreq %>% filter(na_count==0)
yearNAs <- as.data.frame(sapply(dfreq_filt[ ,3:as.numeric(ncol(dfreq_filt)-1)], function(x) sum(length(which(is.na(x))))))
yearNAs$year <- rownames(yearNAs)
yearNAs <- rename(yearNAs, "num_NA"="sapply(dfreq_filt[, 3:as.numeric(ncol(dfreq_filt) - 1)], function(x) sum(length(which(is.na(x)))))")
ggplot(yearNAs, aes(y=num_NA, x=year)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title="Histogram of the number of NAs per year for final SNP set", y="Total NA Count", x="Year")
ggsave("PLOT_Histogram_NAcountByYear.nInd15.pdf", plot=last_plot())



# save table of the loci for input into ANGSD
write.table(dfreq_filt[,1:2], file="DS_history_lociForNe.nInd15.noNA.fromCalledGenos.txt", sep=":", quote=FALSE, row.names=FALSE, col.names=FALSE)
