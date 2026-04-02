#!/bin/bash

set -euo pipefail

METADATA=./data/clean_metadata.tsv
CLEAN_DIR=./data/clean
PROFILE_DIR=./data/taxonomic_profile
BOWTIE2_DIR="${PROFILE_DIR}/bowtie2"

if ! command -v metaphlan >/dev/null 2>&1; then
    echo "Error: metaphlan is not available in PATH." >&2
    exit 1
fi

mkdir -p "${PROFILE_DIR}" "${BOWTIE2_DIR}"

tail -n +2 "${METADATA}" | while IFS=$'\t' read -r sample_number timepoint treatment replicate fwd rev; do
    sample_id="sample${sample_number}_${timepoint}_${treatment}_rep${replicate}"
    clean_fwd="${CLEAN_DIR}/${fwd/_1.fq.gz/_1_clean.fq.gz}"
    clean_rev="${CLEAN_DIR}/${rev/_2.fq.gz/_2_clean.fq.gz}"
    profile_out="${PROFILE_DIR}/${sample_id}_metaphlan_profile.tsv"
    bowtie2_out="${BOWTIE2_DIR}/${sample_id}.bowtie2.bz2"

    if [ ! -f "${clean_fwd}" ]; then
        echo "Error: missing cleaned forward reads for ${sample_id}: ${clean_fwd}" >&2
        exit 1
    fi

    if [ ! -f "${clean_rev}" ]; then
        echo "Error: missing cleaned reverse reads for ${sample_id}: ${clean_rev}" >&2
        exit 1
    fi

    echo "Profiling ${sample_id}"
    metaphlan "${clean_fwd},${clean_rev}" \
        --input_type fastq \
        --bowtie2out "${bowtie2_out}" \
        -o "${profile_out}"
done

if command -v merge_metaphlan_tables.py >/dev/null 2>&1; then
    merge_metaphlan_tables.py "${PROFILE_DIR}"/*_metaphlan_profile.tsv \
        > "${PROFILE_DIR}/metaphlan_merged_abundance.tsv"
fi
