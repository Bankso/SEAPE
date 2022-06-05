#!/usr/bin/bash

in_dir=$1
out_dir=$2
dyads=$3
cdir=${out_dir}/counts
mkdir -p $cdir

for file in ${in_dir}/*
do
fname=${file##*/}
out=${out_dir}/${fname}_dyad_sets.tsv
bedtools intersect -a $file -b $dyads -wo > $out
bedtools intersect -a $file -b $dyads -c > $cdir/${fname}_dyad.counts
done

