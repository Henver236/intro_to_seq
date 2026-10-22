#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$HOME/intro-to-seq
DATA_DIR="$PROJECT_DIR/data"
REF_DIR="$DATA_DIR/ref_genome"

mkdir -p $REF_DIR
cd $REF_DIR

# esearch -db nuccore -query 'U00096' | efetch -format fasta > ecoli-strK12-MG1655.fasta


wget -O "$REF_DIR/ecoli-strK12-MG1655.fasta" \
     "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=545778205&rettype=fasta&retmode=text"

echo "=== Reference genome downloaded ==="