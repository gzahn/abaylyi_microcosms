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

module load miniforge3
# initialize conda (let it have some control of your $PATH, etc.)
source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate de-env

# step 1: run fastp (no quality trimming???)
if [ ! -f "./data/clean/V350357263_L03_18_2_clean.fq.gz" ]; then
./scripts/01_clean_raw_data.sh
fi

# step 2: assign taxonomy with kraken2


