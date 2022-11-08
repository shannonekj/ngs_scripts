#!/bin/bash

set -x

# infile should be file with all loci totals (haven't removed 0's yet)
infile=$1

# read in header line
header=$(sed -n 1p ${infile}) 
grep -v $'\t''0'$'\t''0'$'\t''0'$'\t''0'$'\t''0'$'\t''0'$'\t''0'$'\t''0' ${infile} > ${infile}.no0.counts
echo ${header} > ${infile}.no0.counts.sort
sort -nrk 9 ${infile}.no0.counts >> ${infile}.no0.counts.sort
rm ${infile}.no0.counts
gzip ${infile}
