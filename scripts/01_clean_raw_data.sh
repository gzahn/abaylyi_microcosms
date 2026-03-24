#/bin/bash

for i in $(cat ./data/clean_metadata.tsv | cut -f5 | tail -n +2); 
do FWD=./data/raw/${i}; 
REV=${FWD/_1.fq.gz/_2.fq.gz}; 
OUTFWD=./data/clean/${i/_1.fq.gz/_1_clean.fq.gz}; 
OUTREV=${OUTFWD/_1_clean.fq.gz/_2_clean.fq.gz}; 


# running fastp 
# remove low-complexity
# remove ploy-X tails
# minimum 50 nt
fastp -i $FWD -I $REV -o $OUTFWD -O $OUTREV -x -y -l 50 --html /dev/null --json /dev/null
done
