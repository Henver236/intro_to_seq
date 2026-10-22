#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
REF_DIR="$DATA_DIR/ref_genome"

cd $REF_DIR

bowtie2-build ecoli-strK12-MG1655.fasta ecoli-strK12-MG1655.fasta

echo "=== Index building complete ==="
