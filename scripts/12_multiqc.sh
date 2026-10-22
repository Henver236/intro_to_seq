#!/usr/bin/env bash

# Enable strict error handling:
# -E: Inherit ERR traps in functions and subshells.
# -e: Exit immediately if a command fails.
# -u: Treat unset variables as errors.
# -o pipefail: Return a failure status if any command in a pipeline fails.
set -Eeuo pipefail

# ======================================================================
# MultiQC - Quality control report for the sequencing analysis pipeline
# ======================================================================

# Define the root directory of the project.
# $HOME refers to the current user's home directory.
PROJECT_DIR="$HOME/intro-to-seq"

# Define the directory containing the pipeline scripts.
SCRIPT_DIR="${PROJECT_DIR}/scripts"

# Define input directories and files.
# FastQC ZIP archives contain the quality control results for each sample.
FASTQC_DIR="${PROJECT_DIR}/data/fastqc_output"

# FastQC results generated after read trimming.
FASTQC_TRIMMED_DIR="${PROJECT_DIR}/data/fastqc_output_trimmed"

# fastp JSON report containing trimming and filtering statistics.
FASTP_JSON="${PROJECT_DIR}/data/trimmed/fastp.json"

# Bowtie2 alignment log containing mapping statistics and diagnostic messages.
BOWTIE2_LOG="${PROJECT_DIR}/data/alignments/bowtie2_SRR519926.log"

# Define the output directory for the MultiQC report.
OUT_DIR="${PROJECT_DIR}/data/multiqc_output"

# ------------------------------------------------------------
# Check whether MultiQC is installed and available in PATH.
# command -v checks whether a command can be found.
# >/dev/null 2>&1 suppresses both standard output and error output.
# The ! operator reverses the exit status of the command.
# >&2 redirects the error message to standard error.
# exit 1 terminates the script with a non-zero status.
# ------------------------------------------------------------
if ! command -v multiqc >/dev/null 2>&1; then
    echo "Error: MultiQC is not installed or is not available in PATH." >&2
    exit 1
fi

# ------------------------------------------------------------
# Check that the required input directories exist.
# -d tests whether a path exists and is a directory.
# The for loop checks each directory in the list.
# If a directory is missing, stop the script and report the error.
# ------------------------------------------------------------
for dir in "$FASTQC_DIR" "$FASTQC_TRIMMED_DIR"; do
    if [[ ! -d "$dir" ]]; then
        echo "Error: Input directory not found: $dir" >&2
        exit 1
    fi
done

# Check that the fastp JSON report exists.
# -f tests whether a path exists and is a regular file.
if [[ ! -f "$FASTP_JSON" ]]; then
    echo "Error: fastp report not found: $FASTP_JSON" >&2
    exit 1
fi

# ------------------------------------------------------------
# Collect FastQC reports generated before and after trimming.
# Initialize an empty Bash array to store input file paths.
# ------------------------------------------------------------
INPUTS=()

# Enable nullglob temporarily.
# This prevents unmatched wildcard patterns from being kept
# as literal strings when no files match the pattern.
shopt -s nullglob

# Collect all FastQC ZIP archives from the original reads.
FASTQC_FILES=("$FASTQC_DIR"/*_fastqc.zip)

# Collect all FastQC ZIP archives from the trimmed reads.
FASTQC_TRIMMED_FILES=("$FASTQC_TRIMMED_DIR"/*_fastqc.zip)

# Disable nullglob to restore the default shell behavior.
shopt -u nullglob

# Check that at least one original FastQC report was found.
# ${#FASTQC_FILES[@]} returns the number of elements in the array.
# (( ... )) evaluates an arithmetic expression in Bash.
if (( ${#FASTQC_FILES[@]} == 0 )); then
    echo "Error: No *_fastqc.zip files found in $FASTQC_DIR" >&2
    exit 1
fi

# Check that at least one FastQC report was generated after trimming.
if (( ${#FASTQC_TRIMMED_FILES[@]} == 0 )); then
    echo "Error: No *_fastqc.zip files found in $FASTQC_TRIMMED_DIR" >&2
    exit 1
fi

# Add the original FastQC reports to the input array.
# The += operator appends elements to an existing Bash array.
INPUTS+=("${FASTQC_FILES[@]}")

# Add the FastQC reports generated after trimming.
INPUTS+=("${FASTQC_TRIMMED_FILES[@]}")

# Add the fastp JSON report to the input array.
INPUTS+=("$FASTP_JSON")

# ------------------------------------------------------------
# Add the Bowtie2 log if it exists.
# This input is optional: the script can continue without it.
# ------------------------------------------------------------
if [[ -f "$BOWTIE2_LOG" ]]; then
    INPUTS+=("$BOWTIE2_LOG")
else
    echo "Warning: Bowtie2 log not found; it will be skipped." >&2
fi

# ------------------------------------------------------------
# Create the output directory if it does not already exist.
# -p creates parent directories as needed and does not report
# an error if the directory already exists.
# ------------------------------------------------------------
mkdir -p "$OUT_DIR"

# ------------------------------------------------------------
# Run MultiQC to aggregate the quality control results.
# Print the project and output paths for logging purposes.
# ------------------------------------------------------------
echo "Starting MultiQC..."
echo "Project root: $PROJECT_DIR"
echo "Output directory: $OUT_DIR"

# Run MultiQC using the collected input files.
# "${INPUTS[@]}" expands the array into separate command arguments,
# preserving file paths that contain spaces.
#
# --outdir specifies the output directory.
# --filename sets the name of the generated HTML report.
# --force allows MultiQC to overwrite an existing report.
multiqc "${INPUTS[@]}" \
    --outdir "$OUT_DIR" \
    --filename multiqc_report.html \
    --force

# Print a completion message and the path to the HTML report.
echo "MultiQC completed successfully."
echo "HTML report: ${OUT_DIR}/multiqc_report.html"
