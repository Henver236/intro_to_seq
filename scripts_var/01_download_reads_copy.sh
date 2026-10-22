#!/usr/bin/env bash

PROJECT_DIR=~/intro-to-seq/project
READS_DIR=$PROJECT_DIR/reads
SEQ=SRR519926

# Download the reads from the SRA database using the sra-tools package.
cd $PROJECT_DIR
mkdir -p $READS_DIR
cd $READS_DIR
prefetch $SEQ
fastq-dump --split-files $SEQ

# Puting the reads in a subdirectory named after the sequence accession number:
mkdir -p $READS_DIR/$SEQ
cp $READS_DIR/${SEQ}*.fastq $READS_DIR/$SEQ/

# To compress the reads, you can use the gzip command:
# gzip $READS_DIR/$SEQ/*.fastq

# You can count the number of reads in a fastq file by counting the number of lines and dividing by four.
## forward read & reverse read
echo $(cat $READS_DIR/$SEQ/*.fastq | wc -l)/4 | bc

# Count the number of reads in the forward and reverse files separately:
FORWARD=$(( $(wc -l < "$READS_DIR/$SEQ"/*_1.fastq) / 4 ))
REVERSE=$(( $(wc -l < "$READS_DIR/$SEQ"/*_2.fastq) / 4 ))
# Print the number of reads in the forward and reverse files:
echo "$FORWARD reads in the forward read"
echo "$REVERSE reads in the reverse read"

echo "=== Download complete ==="