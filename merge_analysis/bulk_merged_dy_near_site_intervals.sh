#!/usr/bin/bash
#Use to find merged dyads overlapped by another set of sites
#Designed to iterate across a set of input files for -a with one -b
name=$1
set=$2
frag=$3
size=$4
sites=$5
peak_dyads=$name/merging_analysis/$set/footprint_dyads/$frag
mkdir -p $peak_dyads/$size/
for file in $peak_dyads/*
do
if [ -f $file ] ; then
fname=${file##*/}
out=$fname.$size.bed
bedtools intersect -a $file -b $sites -u > $peak_dyads/$size/$out
wc -l $peak_dyads/$size/$out > $peak_dyads/$size/$out.counts
fi
done
cat $peak_dyads/$size/*.counts | sort -k2 > $peak_dyads/$size/$out.counts.sorted.tsv
