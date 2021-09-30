#!/bin/bash

rm $2
rm $2.o

AA_LEN=30
NT_LEN="$(($AA_LEN * 3))"

echo "CREATING SLIDING WINDOW FILES PER FRAME"
# sliding -s 3 is to keep it in-frame; could alternatively do -s 6|9|12 to spread out the sliding window a bit and reduce size of intermediate files
# this appears to be frame 1
seqkit subseq -r 1:-1 $1 | seqkit sliding -s 30 -W $NT_LEN | sed -E "s|^>(.+)$|>\1 FRAME1|" | seqkit replace -p "\_" -r ' ' > $1.frame1
# this appears to be frame 3
seqkit subseq -r 2:-1 $1 | seqkit sliding -s 30 -W $NT_LEN | sed -E "s|^>(.+)$|>\1 FRAME3|" | seqkit replace -p "\_" -r ' ' > $1.frame3
# this appears to be frame 2
seqkit subseq -r 3:-1 $1 | seqkit sliding -s 30 -W $NT_LEN | sed -E "s|^>(.+)$|>\1 FRAME2|" | seqkit replace -p "\_" -r ' ' > $1.frame2

echo "SPLITTING FRAME FILES"
for i in `ls *.frame*`; do seqkit split $i -i --force; done;


echo "SAMPLING N SEQS FROM EACH FRAME"
for i in *.frame1.split/*; do seqkit sample -n 6 -s $RANDOM $i > $i.sample; done;
for i in *.frame2.split/*; do seqkit sample -n 6 -s $RANDOM $i > $i.sample; done;
for i in *.frame3.split/*; do seqkit sample -n 6 -s $RANDOM $i > $i.sample; done;

echo "CONCATENATING FILES INTO SINGLE OUTPUT"
for i in *.split/*.sample; do cat $i >> full_file.fa; done;
seqkit seq -g -m 3 full_file.fa > $2  # filter out any empty sub-sequences

echo "SORTING OUTPUT"
seqkit rmdup -n $2 | seqkit sort -n > $2.o

../hmmer-3.3.1/easel/miniapps/esl-shuffle $2.o > $2.shuffled.o

rm *.frame*
rm -r *.frame* 
