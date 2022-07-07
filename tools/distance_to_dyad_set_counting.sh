#!/usr/bin/bash

#Determine distance to nearest dyad for a set BED intervals
#Report all overlaps and number of sites overlapped for each interval file
#Calculate total number of JASPAR sites overlapped by an interval and report total with average

db_dyads=$1
outdir=$2
intervals=$3

for file in $intervals/*
do
name=${file##*/}
rawout=$outdir/${name}
bedtools intersect -a $file -b $db_dyads -wo > ${rawout}_ovlp_sites.tsv
bedtools intersect -a $file -b $db_dyads -c > $outdir/counts/${name}.counts
done
for file in $outdir/counts/*
do
awk -F "\t" 'BEGIN {c=0} {c=c+$5} END {print FILENAME, "\t", c, "\t", c/NR}' $file >> $outdir/counts/${name}.counts.total
done



