#!/usr/bin/bash

name=$1
set=$2
frag=$3

out_dir=$name/merging_analysis/$set/can_sites/$frag/counts
out_name=$out_dir
for file in $out_dir/*
do
awk -F "\t" 'BEGIN {s=0} {s=s+$5} END {print FILENAME, "\t", s, "\t", s/NR}' $file >> $file.avgs
done
cat $out_dir/*counts.avgs | sort -k2 > $out_dir/${name}_${set}_${frag}_can_counts.sorted.tsv
rm -r $out_dir/*.avgs

