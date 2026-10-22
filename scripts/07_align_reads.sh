#!/usr/bin/env bash

# Ressources here :
# https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#concordant-pairs-match-pair-expectations-discordant-pairs-dont

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
REF_DIR="$DATA_DIR/ref_genome"
TRIMMED_DIR="$DATA_DIR/trimmed"
ALIGNED_DIR="$DATA_DIR/alignments"

mkdir -p $ALIGNED_DIR

bowtie2 \
-X 1000 \
-x $REF_DIR/ecoli-strK12-MG1655.fasta \
-1 $TRIMMED_DIR/trimmed_SRR519926_1.fastq \
-2 $TRIMMED_DIR/trimmed_SRR519926_2.fastq \
> $ALIGNED_DIR/SRR519926.sam \
--dovetail

echo "=== Alignment complete ==="
