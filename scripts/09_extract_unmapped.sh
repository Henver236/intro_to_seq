#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
ALIGNED_DIR="$DATA_DIR/alignments"

cd $ALIGNED_DIR

samtools view -bh -f 0x4 SRR519926.sorted.bam > SRR519926.sorted.unmapped.bam

echo "=== Extract Unmapped Reads complete ==="