#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
TRIMMED_DIR="$DATA_DIR/trimmed"
REF_DIR="$DATA_DIR/ref_genome"
ALIGNED_DIR="$DATA_DIR/alignments"

bowtie2 \
-x $REF_DIR/ecoli-strK12-MG1655.fasta \
-1 $TRIMMED_DIR/trimmed_SRR519926_1.fastq \
-2 $TRIMMED_DIR/trimmed_SRR519926_2.fastq \
2> $ALIGNED_DIR/bowtie2_SRR519926.log \
| samtools sort - \
| samtools view -bh - \
> $ALIGNED_DIR/SRR519926.sorted.mapped.frompipe.bam

echo "[INFO] Alignment, sorting and conversion to BAM format complete."
