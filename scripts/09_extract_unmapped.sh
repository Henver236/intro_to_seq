#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
ALIGNED_DIR="$DATA_DIR/alignments"

cd $ALIGNED_DIR

# ============================================================
# Extract unmapped reads from a BAM file
# ============================================================

samtools view -bh -f 0x4 SRR519926.sorted.bam > SRR519926.sorted.unmapped.bam

# -b: Write the output in BAM format (binary alignment format)
#     instead of SAM text format.
# -h: Include the BAM header in the output.
#     The header contains reference sequence information and
#     alignment metadata.
# -f 0x4: Include only records for which the specified SAM flag
#         is set.
#
#         The hexadecimal value 0x4 corresponds to SAM flag 4,
#         meaning that the read is unmapped.
#
#         This flag is part of the SAM format's bitwise FLAG
#         field, which describes properties of each alignment.
#
# The > operator redirects standard output to the output file.
# If the output file already exists, it will be overwritten.

echo "=== Extract Unmapped Reads complete ==="