#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR=~/intro-to-seq/project
READS_DIR="$PROJECT_DIR/reads"
QC_OUTPUT="$PROJECT_DIR/fastqc_output"
TRIMMED_DIR="$PROJECT_DIR/trimmed"

mkdir -p "$TRIMMED_DIR"
cd "$TRIMMED_DIR"

# Detect file pairs (common patterns: *_1/_2 or *_R1/*_R2)
shopt -s nullglob nocaseglob
PAIRS=( "$READS_DIR"/*_1.fastq "$READS_DIR"/*_2.fastq "$READS_DIR"/*_R1.fastq "$READS_DIR"/*_R2.fastq )
shopt -u nullglob nocaseglob

if (( ${#PAIRS[@]} == 0 )); then
    echo "No FASTQ files found in $READS_DIR" >&2
    exit 1
fi

# Extract unique sample names (everything preceding _1, _2, _R1, or _R2)
declare -A SAMPLES
for FILE in "${PAIRS[@]}"; do
    BASENAME=$(basename "$FILE")
    # Strip _1.fastq, _2.fastq, _R1.fastq, _R2.fastq (or .gz)
    SAMPLE_NAME="${BASENAME%_[12]*.fastq*}"
    SAMPLE_NAME="${SAMPLE_NAME%_R[12].fastq*}"
    if [[ -n "$SAMPLE_NAME" ]]; then
        SAMPLES["$SAMPLE_NAME"]=1
    fi
done

# For each sample, look for the matching pair
for SAMPLE in "${!SAMPLES[@]}"; do
    echo "=== Processing sample: $SAMPLE ==="

    FORWARD=""
    REVERSE=""

    # Look for the forward read (_1 or _R1)
    for PAT in "$READS_DIR"/${SAMPLE}_1.fastq "$READS_DIR"/${SAMPLE}_R1.fastq; do
        shopt -s nullglob
        MATCH=($PAT)
        shopt -u nullglob
        if (( ${#MATCH[@]} == 1 )); then
            FORWARD="${MATCH[0]}"
            break
        fi
    done

    # Look for the reverse read (_2 or _R2)
    for PAT in "$READS_DIR"/${SAMPLE}_2.fastq "$READS_DIR"/${SAMPLE}_R2.fastq; do
        shopt -s nullglob
        MATCH=($PAT)
        shopt -u nullglob
        if (( ${#MATCH[@]} == 1 )); then
            REVERSE="${MATCH[0]}"
            break
        fi
    done

    # Check that the pair is complete
    if [[ -z "$FORWARD" || -z "$REVERSE" ]]; then
        echo "Warning: Incomplete pair for $SAMPLE (forward: ${FORWARD:-missing}, reverse: ${REVERSE:-missing})" >&2
        continue
    fi

    OUTPUT_PREFIX="trimmed_${SAMPLE}"
    echo "Forward  : $FORWARD"
    echo "Reverse  : $REVERSE"
    echo "Output   : $OUTPUT_PREFIX_{1,2}.fastq"

    fastp \
        -i "$FORWARD" \
        -I "$REVERSE" \
        -o "$TRIMMED_DIR/${OUTPUT_PREFIX}_1.fastq" \
        -O "$TRIMMED_DIR/${OUTPUT_PREFIX}_2.fastq" \
        --qualified_quality_phred 15 \
        --length_required 15 \
        --unqualified_percent_limit 80 \
        --cut_front \
        --cut_tail \
        --detect_adapter_for_pe
done

# --qualified_quality_phred 20      # Minimum mean quality
# --length_required 50              # Min length after trimming
# --unqualified_percent_limit 40    # Max % of low-quality bases

echo "=== Trimming complete ==="

