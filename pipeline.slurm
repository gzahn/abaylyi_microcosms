#!/bin/bash
#SBATCH --job-name=abaylyi
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --time=2-00:00:00
#SBATCH --mem=980G
#SBATCH --exclusive
#SBATCH --partition=gz #lab nodes
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=gzahn@wm.edu
#SBATCH -o /sciclone/home/gzahn/logs/test_%j.out
#SBATCH -e /sciclone/home/gzahn/logs/test_%j.err

##### SET UP ENVIRONMENT #####

module load miniforge3
# initialize conda (let it have some control of your $PATH, etc.)
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate de-env

# ensure directory structure
if [ ! -d "./data/raw" ]; then
mkdir -p ./data/raw
fi

if [ ! -d "./data/clean" ]; then
mkdir -p ./data/clean
fi

if [ ! -d "./output" ]; then
mkdir -p ./output
fi

##################################################################

##### QUALITY CONTROL #####

# step 1: run fastp (no quality trimming???)
if [ ! -f "./data/clean/V350357263_L03_18_2_clean.fq.gz" ]; then
./scripts/01_clean_raw_data.sh
fi

##################################################################

##### TAXONOMIC PROFILE #####

# step 2: assign taxonomy with kraken2

# get db if needed
if [ ! -f "./data/ref/hash.k2d" ]; then
./scripts/download_kraken2_core_nt.sh
if

# run kraken2 if needed
# find 'last' sample in metadata
LAST=$(cat ./data/clean_metadata.tsv | cut -f5 | tail -n 1)
K2OUT=./output/${LAST%_1.fq.gz}_kraken2_output.txt

if [ ! -f $K2OUT ]; then
./scripts/02_taxonomic_profile.sh
fi

##################################################################

##### DEPLETE rRNA #####

