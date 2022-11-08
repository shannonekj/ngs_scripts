#!/bin/bash

set -x

infile=$1
outfile=$2

sort -nrk 10 ${infile} >> ${outfile}
