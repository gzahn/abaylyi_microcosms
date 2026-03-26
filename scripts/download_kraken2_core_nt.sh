#!/bin/bash

# make database directory if needed
if [ ! -d "./data/ref" ]; then
mkdir -p ./data/ref
fi

# get core_nt database if needed
if [ ! -f "./data/ref/k2_core_nt_20251015.tar.gz" ]; then
wget -P ./data/ref/https://genome-idx.s3.amazonaws.com/kraken/k2_core_nt_20251015.tar.gz
fi

# extract tarball if needed
if [ ! -f "./data/ref/hash.k2d" ]; then
tar -C "./data/ref" -xzvf "./data/ref/k2_core_nt_20251015.tar.gz"
fi

