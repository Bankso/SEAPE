#!/usr/bin/bash

indir="$1" #footprints made from mixed intervals
outdir="$2" # overlap of footprints with raw dyad set
dyads="$3" # requested dyads to be checked for coverage
cdir="$4"
for file in ${indir}/*
do
	if [ -f "${file}" ]; then
		ovname="$(basename "${file%.*}")_dyad_ovlp.tsv"
		cname="$(basename "${ovname%.*}").counts"
		ovout="${outdir}/${ovname}"
		cout="${cdir}/${cname}"
		bedtools intersect -a "${file}" -b "${dyads}" -wo > "${ovout}"
		bedtools intersect -a "${file}" -b "${dyads}" -c > "${cout}"
	fi
done
echo "Raw dyad coverage evaluated for all merge fp intervals"
