#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
READS_DIR=$DATA_DIR/reads
mkdir -p "$DATA_DIR/fastqc_output"
QC_OUTPUT="$DATA_DIR/fastqc_output"
SEQ=SRR519926

# Run FastQC on the downloaded reads :
fastqc "$READS_DIR"/*.fastq --outdir "$QC_OUTPUT"

echo "=== FastQC complete ==="


