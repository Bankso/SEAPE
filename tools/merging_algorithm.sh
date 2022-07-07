#!/usr/bin/bash
#Calculates a set of files containing recalculated dyads corresponding to merges of increasing distance
#One file for each value of c in the while loop
#Takes a set of dyads as input, an outdir for new dyad files, a max dis (1/2 total region) to search
#and and increment to increase c by after each merge/recalc
dyads="$1" # A set of dyads to be processed
out="$2" # Out directory
mindis="$3" # Maximum distance for regions to be merged within
maxdis="$4" # Maximum distance for regions to be merged within
tsize=["$maxdis"*2]
inc="$5" # Number of bp to add to counter after each merge
c="${mindis}" # Counter to limit merge distance
echo "Dyads will be merged in increments of $inc bp up to a $tsize bp symmetric region around each entry"
srtdy="$(basename "${dyads%.*}")_sorted.bed"
sort -k1,1 -k2,2n "${dyads}" > "${out}/${srtdy}"
while [ ${c} -le ${maxdis} ]
do
	mout="${out}/${c}"
	mkdir -p "${mout}"
	mergout="${srtdy%.*}_${c}_merged.bed"
	newdy="${srtdy%.*}_${c}_merged_dyads.bed"
	newfp="${srtdy%.*}_${c}_merged_.bed"
	dypr="${srtdy%.*}_${c}_dypr_calc.tsv"
	hist="${srtdy%.*}_${c}_hist_outs.tsv"
	bedtools merge -i "${out}/${srtdy}" -d "${c}" > "${mout}/${mergout}"
	#echo "Dyads merged to current count value"
	awk '{ m = int($2+($3-$2)/2); print $1,'\t', m, '\t', m + 1, '\t', '.', '\n' }' "${mout}/${mergout}" > "${mout}/${newdy}"
	awk '{ m = int($2+($3-$2)/2); print $1,'\t', m, '\t', m + 1, '\t', '.', '\n' }' "${mout}/${newdy}" > "${mout}/${newfp}"
	bedtools intersect -C -a "${mout}/${newpr}" -b "${dyads}" > "${mout}/${dypr}"
	bedtools intersect -c -a "${mout}/${newpr}" -b "${dyads}" > "${mout}/${hist}"
	#echo New dyads to made and moved to outdir
	wc -l "${mout}/${mergout}" > "${mout}/${srtdy%.*}_entry.count"
	rm "${mout}/${mergout}" # extra file can be removed
	c=$[${c} + ${inc}]
done
echo "Calculations completed for input dyads up to max distance"
