#/bin/bash

# loop through file names as before, using QC 'clean' files
for i in $(cat ./data/clean_metadata.tsv | cut -f5 | tail -n +2);
do

# set input files in loop
FWD=./data/clean/${i/_1.fq.gz/_1_clean.fq.gz};
REV=${FWD/_1_clean.fq.gz/_2_clean.fq.gz};
REP=./output/${i%_1.fq.gz}_kraken2_report.txt
OUT=./output/${i%_1.fq.gz}_kraken2_output.txt

# run kraken2
kraken2 --db ./data/ref --gzip-compressed --threads 20 --paired --report $REP --output $OUT $FWD $REV

done
