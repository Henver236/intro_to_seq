#!/usr/bin/env bash

set -euo pipefail

# Let's set the variables for the project directory and the reads directory.
PROJECT_DIR=$HOME/intro-to-seq
SCRIPTS_DIR="$PROJECT_DIR/scripts"
SCRIPTS_VAR="$PROJECT_DIR/scripts_var"

### 01_download_reads.sh ######################################
bash "$SCRIPTS_DIR"/01_download_reads.sh
# bash "$SCRIPTS_VAR"/01_download_reads_copy.sh

### 02_run_fastqc.sh ##########################################
bash "$SCRIPTS_DIR"/02_run_fastqc.sh
# bash "$SCRIPTS_VAR"/02_run_fastqc_copy.sh

### 03_trim_reads.sh ##########################################
bash "$SCRIPTS_DIR"/03_trim_reads.sh
# bash "$SCRIPTS_VAR"/03_trim_reads_copy.sh

### 04_run_fastqc_trimmed.sh ##################################
bash "$SCRIPTS_DIR"/04_run_fastqc_trimmed.sh

### 05_download_ecoli_reference.sh ############################
bash "$SCRIPTS_DIR"/05_download_ecoli_reference.sh

### 06_index_reference.sh #####################################
bash "$SCRIPTS_DIR"/06_index_reference.sh

### 07_align_reads.sh #########################################
bash "$SCRIPTS_DIR"/07_align_reads.sh

### 08_compress_sort.sh #######################################
bash "$SCRIPTS_DIR"/08_compress_sort.sh

### 09_extract_unmapped.sh ####################################
bash "$SCRIPTS_DIR"/09_extract_unmapped.sh

### 10_extract_region.sh ######################################
bash "$SCRIPTS_DIR"/10_extract_region.sh

### 11_align_sort.sh ##########################################
bash "$SCRIPTS_DIR"/11_align_sort.sh

### 12_multiqc.sh ##########################################
bash "$SCRIPTS_DIR"/12_multiqc.sh

