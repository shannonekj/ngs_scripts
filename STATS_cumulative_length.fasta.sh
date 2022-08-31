#!/bin/bash
# File      : STATS_cumulative_length.fasta.sh
# Author    : Shannon EK Joslin
# Date      : 31 August 2022

# This file will take in a fasta file and produce a cumulative length file for plotting/visualization.
# RUN CMD = bash STATS_cumulative_length.fasta.sh <fasta_file> <output_prefix>
# INPUT = gzipped or not fasta
# OUTPUT = | read length | cumulative length |

fileend=$(echo $1 | rev | cut -f 1 -d. | rev)
if [ $fileend = 'gz' ]
then
    zcat $1 | perl -ne '$id=$_; $seq=<>; chomp $seq; print length($seq)."\n"' | sort -rn | perl -ne '$len=$_; chomp $len; $all+=$len; print "$len\t$all\n"' > ${2}.cl
elif [ $fileend = 'fasta' ] || [ $fileend = 'fa' ]
then
    cat $1 | perl -ne '$id=$_; $seq=<>; chomp $seq; print length($seq)."\n"' | sort -rn | perl -ne '$len=$_; chomp $len; $all+=$len; print "$len\t$all\n"' > ${2}.cl
else
    echo "File does not have one of the following endings: .gz .fasta .fa"
fi
