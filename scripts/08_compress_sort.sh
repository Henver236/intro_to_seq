#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
ALIGNED_DIR="$DATA_DIR/alignments"

cd $ALIGNED_DIR

samtools view -bh SRR519926.sam > SRR519926.bam 
echo "[INFO] SAM file converted to BAM format."

samtools sort SRR519926.bam > SRR519926.sorted.bam
echo "[INFO] BAM file sorted."

samtools index SRR519926.sorted.bam
echo "[INFO] BAM file indexed."

echo "=== SamTools Compression complete ==="

