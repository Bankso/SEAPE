#!/usr/bin/bash

name=$1
set=$2
umf=$name/merging_analysis/unmerged_footprints/$set
mfp=$name/merging_analysis/mixed_intervals/$set
for file in $umf/*
do
if [ -f $file ] ; then
fname=${file##*/}
out=$fname.merged
sort -k1,1 -k2,2n $file |bedtools merge > $mfp/$out
wc -l $mfp/$out > $mfp/$out.counts
fi
done
cat $mfp/*.counts | sort -k2 > $mfp/${name}_${set}_counts.tsv
