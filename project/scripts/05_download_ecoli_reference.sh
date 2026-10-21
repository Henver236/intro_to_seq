#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=~/intro-to-seq/project


mkdir -p "$PROJECT_DIR/ref_genome"
cd "$PROJECT_DIR/ref_genome"

wget https://ngs-introduction-training.s3.eu-central-1.amazonaws.com/project2.tar.gz
tar -xvf project2.tar.gz
rm project2.tar.gz


