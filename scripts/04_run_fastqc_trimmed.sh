#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
READS_DIR=$DATA_DIR/reads
TRIM_DIR=$DATA_DIR/trimmed
REFERENCE_DIR="$PROJECT_DIR/ref_genome"   
mkdir -p "$DATA_DIR/fastqc_output_trimmed"
QC_OUTPUT="$DATA_DIR/fastqc_output_trimmed"

echo "=== FastQC on trimmed reads started ==="

# Run FastQC on the downloaded reads :
fastqc "$TRIM_DIR"/*.fastq --outdir "$QC_OUTPUT"

echo "Done → $QC_OUTPUT"
echo "=== FastQC on trimmed reads complete ==="