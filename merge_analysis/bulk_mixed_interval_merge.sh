#!/usr/bin/bash

name=$1
set=$2
umf=$name/merging_analysis/$set/unmerged_footprints
for file in $umf/*
do
if [ -f $file ] ; then
fname=${file##*/}
out=$fname.merged
sort -k1,1 -k2,2n $file |bedtools merge > $name/merging_analysis/$set/mixed_intervals/$out
wc -l $name/merging_analysis/$set/mixed_intervals/$out > $name/merging_analysis/$set/mixed_intervals/$out.counts
fi
done
cat $name/merging_analysis/$set/mixed_intervals/*.counts | sort -k2 > $name/merging_analysis/$set/mixed_intervals/all_counts.tsv
