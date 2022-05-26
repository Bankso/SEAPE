#!/usr/bin/bash

name=$1
set=$2
frag=$3

if [ $frag == ff ] ; then
merge_files=$name/merging_analysis/$set/full_print_regions/ff
dyads=$name/motif_analysis/bed_intervals/*dyads.bed
out_files=$name/merging_analysis/$set/can_sites/ff
echo $merge_files
echo $dyads
echo $out_files
for file in ${merge_files}/*
do
fname=${file##*/}
out=${out_files}/${fname}_dyad_sets.tsv
bedtools intersect -a $file -b $dyads -wo > $out
bedtools intersect -a $file -b $dyads -c > ${out_files}/counts/${fname}_dyad.counts
done
elif [ $frag == sf ] ; then
merge_files=$name/merging_analysis/$set/full_print_regions/sf
dyads=$name/motif_analysis/bed_intervals/*dyads.bed
out_files=$name/merging_analysis/$set/can_sites/sf
echo $merge_files
echo $dyads
echo $out_files
for file in ${merge_files}/*
do
fname=${file##*/}
out=${out_files}/${fname}_dyad_sets.tsv
bedtools intersect -a $file -b $dyads -wo > $out
bedtools intersect -a $file -b $dyads -c > ${out_files}/counts/${fname}_dyad.counts
done
fi
