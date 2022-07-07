#!/usr/bin/bash

indir="$1" # calculated footprints from merge calculations
outdir="$2" # overlap of footprints with FIMO dyads
fimos="$3" # requested FIMO sites/dyads to be checked for coverage
cdir="${outdir}/counts"
mkdir -p "${cdir}"
for file in ${indir}/*
do
	if [ -f "${file}" ]; then
		ovname="$(basename "${file%.*}")_fimo_ovlp.tsv"
		cname="$(basename "${ovname%.*}").counts"
		ovout="${outdir}/${ovname}"
		cout="${cdir}/${cname}"
		bedtools intersect -a "${file}" -b "${fimos}" -wo | uniq > "${ovout}" # Report all prints and their overlapped fimos
		bedtools intersect -a "${fimos}" -b "${file}" -u > "${cout}" # Report any fimo dyad if it is in a print
		
	fi
done
wc -l $cdir/*.counts | sort -k2 > $cdir/fimo_dyad_counts.tsv
echo "Calculated region dyads compared to input FIMO intervals"
