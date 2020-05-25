#!/bin/bash
# File      : STATS_cumulative_length.fastq.sh
# Author    : Shannon EK Joslin
# Date      : 25 May 2020

# This file will take in a gzipped fastq file and produce a cumulative length file for plotting/visualization.
# RUN CMD = bash STATS_cumulative_length.fastq.sh <fastq_file> <output_prefix>
# INPUT = gzipped fastq
# OUTPUT = | read length | cumulative length

zcat $1 \
| perl -ne '$id=$_; $seq=<>; $zip=<>; $qual=<>; chomp $seq; print length($seq)."\n"' \
| sort -rn | perl -ne '$len=$_; chomp $len; $all+=$len; print "$len\t$all\n"' \
> ${2}.cl
