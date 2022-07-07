#!/usr/bin/bash

indir="$1" #timepoint dyads from peaks
outdir="$2" # dyads located in canonical site regions
regions="$3" # regions to filter dyads through
cdir="$2/counts" # out location for the counts
mkdir -p $cdir
for file in ${indir}/*
do
	if [ -f "${file}" ]; then
		ovname="$(basename "${file%.*}")_fimo_ovlp.tsv"
		cname="$(basename "${ovname%.*}").counts"
		sname="$(basename "${file%.*}")_in_sites.bed"
		ovout="${outdir}/${ovname}"
		cout="${cdir}/${cname}"
		sout="${outdir}/${sname}"
		bedtools intersect -a "${regions}" -b "${file}" -wo > "${ovout}"
		bedtools intersect -a "${regions}" -b "${file}" -c > "${cout}"
		awk 'BEGIN {OFS="\t"}; { print $6,$7,$8,$9,"",$5 }' "${ovout}" | sort -k1,1 -k2,2n | uniq > "${sout}"
		wc -l "${sout}" >> "${outdir}/dyad_counts.txt"
	fi
done
echo "Timepoint dyads filtered by requested regions"
