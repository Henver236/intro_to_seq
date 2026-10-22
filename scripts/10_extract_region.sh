#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
ALIGNED_DIR="$DATA_DIR/alignments"

cd $ALIGNED_DIR

# ============================================================
# Extract alignments overlapping a specific genomic region
# ============================================================

samtools view -bh \
SRR519926.sorted.bam \
U00096.3:2000000-2500000 \
> SRR519926.sorted.region.bam

# Use samtools view to extract alignment records from a BAM file
# that overlap a specified region of the reference genome.
#
# Input BAM file:
# SRR519926.sorted.bam
#
# Target genomic region:
# U00096.3:2000000-2500000
#
# This region corresponds to reference sequence U00096.3,
# from position 2,000,000 to position 2,500,000 (inclusive
# in the SAMtools region notation).
#
# samtools view options:
#
# -b: Output the selected alignments in BAM format
#     (binary alignment format), rather than SAM text format.
#
# -h: Include the BAM header in the output.
#     The header contains metadata such as reference sequence
#     names, sequence lengths and alignment information.
#
# The region argument restricts the output to alignments
# overlapping the specified genomic interval.
#
# The > operator redirects standard output to the output file.
# If the file already exists, it will be overwritten.

# Index creation from the BAM file specified.
samtools index SRR519926.sorted.region.bam
echo "[INFO] BAM file indexed."

echo "=== Extract Region complete ==="