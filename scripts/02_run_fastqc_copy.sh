#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=~/intro-to-seq/project
READS_DIR="$PROJECT_DIR/reads"

mkdir -p "$PROJECT_DIR/fastqc_output"
QC_OUTPUT="$PROJECT_DIR/fastqc_output"

THREADS="${THREADS:-4}"

[[ -d "$READS_DIR" ]] || { echo "Error: '$READS_DIR' does not exist" >&2; exit 1; }

# Subdirectories of reads/ (on macOS: replace -printf '%f\n' with | sed 's|.*/||')
mapfile -t DIRS < <(find "$READS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

(( ${#DIRS[@]} )) || { echo "No subdirectories in $READS_DIR" >&2; exit 1; }

echo "Directories available in $READS_DIR:"
PS3="Number of the directory to analyze (Ctrl-D or 'q' to quit): "

select DIR in "${DIRS[@]}"; do
    [[ -n "${DIR:-}" ]] || { echo "Invalid choice." >&2; continue; }

    TARGET="$READS_DIR/$DIR"
    echo "→ Selected directory: $TARGET"

    shopt -s nullglob nocaseglob
    FILES=( "$TARGET"/*.fastq "$TARGET"/*.fq "$TARGET"/*.fastq.gz "$TARGET"/*.fq.gz )
    shopt -u nullglob nocaseglob

    if (( ${#FILES[@]} == 0 )); then
        echo "No FASTQ files in $TARGET, pick another one." >&2
        continue
    fi

    printf '  %s\n' "${FILES[@]}"
    read -rp "Run FastQC on these ${#FILES[@]} file(s)? [y/N] " ans
    [[ "$ans" =~ ^[yYoO]$ ]] || { echo "Cancelled."; continue; }

    fastqc --outdir "$QC_OUTPUT" --threads "$THREADS" "${FILES[@]}" # Add --extract before "${FILES[@]}" if you want to extract the results.zip files.
    echo "Done → $QC_OUTPUT"
    break
done

