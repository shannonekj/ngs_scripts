#!/bin/bash
# Taken from: https://stackoverflow.com/questions/23992646/sequence-length-of-fasta-file
# NOTE: Must run at cmdline & replace file.fa--still needs to be converted into: bash fasta_sequence_lengths.sh <fasta_file> <outfile>

# one liner: 
awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next; } { seqlen += length($0)}END{print seqlen}' file.fa

# with comments
awk '/^>/ { # header pattern detected
        if (seqlen){
         # print previous seqlen if exists
         print seqlen
         }

         # pring the tag
         print

         # initialize sequence
         seqlen = 0

         # skip further processing
         next
      }

# accumulate sequence length
{
seqlen += length($0)
}
# remnant seqlen if exists
END{if(seqlen){print seqlen}}' file.fa
