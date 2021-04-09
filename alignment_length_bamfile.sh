# Taken from: https://www.biostars.org/p/65216/
# Note: Must run the following command on the command line AKA still need to modify to make the following fmt: alignment_length_bamfile.sh <bam_file> <line_number> 

# Replace: file.bam & <line_num>
samtools view file.bam | head -n <line_num> | tail -n 1 | cut -f 10 | perl -ne 'chomp;print length($_) . "\n"' | sort | uniq -c
