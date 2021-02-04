#!/bin/bash

# This script will get assembly statistics usings Genometools 

###############
###  SETUP  ###
###############

###  Conda  ###
echo "Setting up conda environment"
#. ~/miniconda3/etc/profile.d/conda.sh
source /home/sejoslin/.bashrc
conda activate genometools

###  Variables  ###
echo "Setting up variables"
# external variables
PREFIX=$1		# Prefix to name output file
ASSEMBLY=$2		# Assembly file (global path)
N=$3            # genome size
OUT_DIR=$4		# Path to output directory
# internal variables
stats_file="${OUT_DIR}/${PREFIX}.stats"

echo "  Assembly : ${ASSEMBLY}"
echo "  Output : ${stats_file}"
echo "  Genome Size : ${N}"
echo ""


###################
###  GET STATS  ###
###################

[ -d ${OUT_DIR} ] || mkdir -p ${OUT_DIR}
cd ${OUT_DIR}

stats_call="gt seqstat -contigs -genome ${N} ${ASSEMBLY} > ${stats_file}"
echo ${stats_call}
eval ${stats_call}

