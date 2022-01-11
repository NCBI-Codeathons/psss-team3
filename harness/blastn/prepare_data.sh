#!/usr/bin/env sh
# have three inputs
# 1) stockholm msa with N different protein MSAs,
# 2) stockholm msa file with N different DNA msas,
# 3) and the chromosome (target) fasta database

set -e

DNA_QUERY=$1
AA_QUERY=$2
TARGET=$3

# first, split the MSA into many different MSAs

esl-alistat "$DNA_QUERY" | grep name | awk -F: '{print $2}' > families

cat families | while read family
do
  esl-afetch "$DNA_QUERY" "$family" > "$family".msa
done
# convert each split msa into fasta format
cat families | while read family
do
  esl-reformat fasta "$family".msa > "$family".tmp.fa
done
# gzip and tar each .fa file and place in spread/ directory
mkdir spread
for fa in *tmp.fa
do
  tar -czf spread/"$fa".tar.gz "$fa"
done
# make a blast db (could omit the -out flag and not copy
# target to shared.fa, but it's simple this way)
cp "$TARGET" shared.fa
makeblastdb -dbtype nucl -in shared.fa -out shared
# and archive it. Hardcoding filenames here isn't optimal I guess; maybe *shared*?
tar -czf shared.tar.gz shared.fa shared.ndb shared.nhr shared.nin shared.not shared.nsq shared.ntf shared.nto
