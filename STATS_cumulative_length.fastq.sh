#!/bin/bash
# File      : STATS_cumulative_length.fastq.sh
# Author    : Shannon EK Joslin
# Date      : 29 January 2021

# This file will take in a fastq file and produce a cumulative length file for plotting/visualization.
# RUN CMD = bash STATS_cumulative_length.fastq.sh <fastq_file> <output_prefix>
# INPUT = gzipped or not fastq
# OUTPUT = | read length | cumulative length |

fileend=$(echo $1 | rev | cut -f 1 -d. | rev)
if [ $fileend = 'gz' ]
then
    zcat $1 | perl -ne '$id=$_; $seq=<>; $zip=<>; $qual=<>; chomp $seq; print length($seq)."\n"' | sort -rn | perl -ne '$len=$_; chomp $len; $all+=$len; print "$len\t$all\n"' > ${2}.cl
elif [ $fileend = 'fastq' ] || [ $fileend = 'fq' ]
then
    cat $1 | perl -ne '$id=$_; $seq=<>; $zip=<>; $qual=<>; chomp $seq; print length($seq)."\n"' | sort -rn | perl -ne '$len=$_; chomp $len; $all+=$len; print "$len\t$all\n"' > ${2}.cl
else
    echo "File does not have one of the following endings: .gz .fastq .fq"
fi
