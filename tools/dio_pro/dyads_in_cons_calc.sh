#!/usr/bin/bash

indir="$1" #footprints made from mixed intervals
outdir="$2" # overlap of footprints with raw dyad set
cons="$3" # requested consensus sites to compare to merged dyads
name="$4"
mkdir -p "${outdir}/counts"
for file in ${indir}/*
do
	if [ -f "${file}" ]; then
		ovname="$(basename "${file%.*}")_cs_ovlp.tsv"
		cname="$(basename "${ovname%.*}").counts"
		ovout="${outdir}/${ovname}"
		cout="${outdir}/counts/${cname}"
		bedtools intersect -a "${file}" -b "${cons}" -u > "${ovout}"
		wc -l "${file}" >> "${cout}"
		wc -l "${ovout}" >> "${cout}"
	fi
done
cat ${outdir}/counts/* > ${outdir}/counts/${name}.counts
echo "Merge dyad sets evaluated for overlap with consensus sequences"
