# ngs_scripts
Repository for ngs scripts I use regularly.

## List of scripts
* align_RAD_2019.sh = alignment of RAD data from R1 and R2 fastq files (markdup, fixmate)
* align_ind_fa_2019.sh = basic alignment of data from single fastq file
* barcodes_pst1.csv = comma separated list of Pst1 barcodes
* barcodes_sbf1.csv - comma separated list of Sbf1 barcodes
* BarcodeSplitList3Files.pl = perl script to **split lanes** based on *given* barcode
* BCsplitBestRadPE2.pl = perl script to split each lane by wells via inline barcode. **NOTE** right now requires barcodes to be given in line––make sure the barcodes match the RE
* BUSCOv?.sh = script to run BUSCO version _x_
* RUN_alignment_RAD.slurm = slurm script to submit for aligning RAD PE data
* splitRAD_Pst1.sh = shell script to split lanes and barcodes of RAD data prepped with RE=**Pst1**
* splitRAD_Sbf1.sh = shell script to split lanes and barcodes of RAD data prepped with RE=**Sbf1**

