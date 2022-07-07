#!/usr/bin/bash

name=$1
set=$2
umf=$3
mfp=$4
mkdir -p $mfp
for file in $umf/*
do
	if [ -f $file ] ; then
		fname="$(basename "${file%.*}")_merged.bed"
		cname="$(basename "${file%.*}")_merged.counts"
		fout="${mfp}/${fname}"
		cout="${mfp}/${cname}"
		sort -k1,1 -k2,2n $file |bedtools merge > $fout
		wc -l $fout > $cout
	fi
done
cat $mfp/*.counts | sort -k2 > $mfp/${name}_${set}_counts.tsv
