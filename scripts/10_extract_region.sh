#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
ALIGNED_DIR="$DATA_DIR/alignments"

cd $ALIGNED_DIR

samtools view -bh \
SRR519926.sorted.bam \
U00096.3:2000000-2500000 \
> SRR519926.sorted.region.bam

samtools index SRR519926.sorted.region.bam
echo "[INFO] BAM file indexed."

echo "=== Extract Region complete ==="