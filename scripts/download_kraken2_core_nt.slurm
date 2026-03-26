#!/bin/bash
#SBATCH --job-name=dl_kraken2db
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --time=300
#SBATCH --mem=640G
#SBATCH --exclusive
#SBATCH --partition=gz
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=gzahn@wm.edu
#SBATCH -o get_kraken_db_%j.out
#SBATCH -e get_kraken_db_%j.err

./scripts/download_kraken2_core_nt.sh

