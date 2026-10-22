#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
READS_DIR="$DATA_DIR/reads"
QC_OUTPUT="$DATA_DIR/fastqc_output"
TRIMMED_DIR="$DATA_DIR/trimmed"

mkdir -p "$TRIMMED_DIR"
cd "$TRIMMED_DIR"

echo "=== Trimming started ==="

for FORWARD in "$READS_DIR"/*_1.fastq; do
    BASENAME=$(basename "$FORWARD" _1.fastq)
    REVERSE="$READS_DIR/${BASENAME}_2.fastq"

    if [[ ! -f "$REVERSE" ]]; then
        echo "Skipping $BASENAME - no reverse mate" >&2
        continue
    fi

    fastp \
        -i "$FORWARD" \
        -I "$REVERSE" \
        -o "$TRIMMED_DIR/trimmed_${BASENAME}_1.fastq" \
        -O "$TRIMMED_DIR/trimmed_${BASENAME}_2.fastq" \
        --qualified_quality_phred 15 \
        --length_required 25 \
        --unqualified_percent_limit 80 \
        --cut_front \
        --cut_tail \
        --detect_adapter_for_pe
done

echo "=== Trimming complete ==="

