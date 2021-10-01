#!/usr/bin/env sh
set -e
if [ $# != 2 ];
then
  echo "usage: run_tool.sh <shared_data> <spread_data>"
fi

tar -xzf $1
tar -xzf $2
query_name=$(echo "$2" | sed 's/.tar.gz//g')
outfile=$query_name.out
blastn -task blastn -db shared -query "$query_name" -outfmt 7 -num_threads 1 -out "$outfile"

grep -v \# "$outfile" | awk '{print $11, $12, $9, $10, $2}'