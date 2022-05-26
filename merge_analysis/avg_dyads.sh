#!/usr/bin/bash

name=$1
set=$2
frag=$3

out_dir=$name/merging_analysis/$set/dyads_in_fps/$frag/counts/
out_name=$out_dir/avg_dyads
for file in $out_dir/*
do
awk -F "\t" 'BEGIN {s=0} {s=s+$5} END {print FILENAME, "\t", s/NR}' $file >> $file.avgs
done
cat $out_dir/*counts.avgs | sort -k0 > $out_name.sorted.tsv
rm -r $out_dir/*.avgs

