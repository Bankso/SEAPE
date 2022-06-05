#!/usr/bin/bash

#Calculate the permutations of dyad overlaps between the three sets of predicted binding sites
#used in SpLiT-ChEC analysis

db_dyads=$1
ff_dyads=$2
sf_dyads=$3
outdir=$4
dbname=${db_dyads##*/}
ffname=${ff_dyads##*/}
fname=ff_counting_${dbname}
sname=sf_counting_${dbname}
pname=sf_counting_${ffname}
rawfout=$outdir/${fname}
rawsout=$outdir/${sname}
rawpout=$outdir/${pname}
bedtools intersect -a $ff_dyads -b $db_dyads -c > $rawfout
bedtools intersect -a $sf_dyads -b $db_dyads -c > $rawsout
bedtools intersect -a $sf_dyads -b $ff_dyads -c > $rawpout
wc -l $rawfout $rawsout $rawpout
awk -F "\t" 'BEGIN {c=0} {c=c+$6} END {print FILENAME, "\t", c}' $rawfout >> $outdir/totals_${fname}
awk -F "\t" 'BEGIN {c=0} {c=c+$6} END {print FILENAME, "\t", c}' $rawsout >> $outdir/totals_${sname}
awk -F "\t" 'BEGIN {c=0} {c=c+$6} END {print FILENAME, "\t", c}' $rawpout >> $outdir/totals_${pname}
fout=$outdir/ff_with_${dbname}
sout=$outdir/sf_with_${dbname}
pout=$outdir/sf_with_${ffname}
bedtools intersect -a $ff_dyads -b $db_dyads -u > $fout
bedtools intersect -a $sf_dyads -b $db_dyads -u > $sout
bedtools intersect -a $sf_dyads -b $ff_dyads -u > $pout
wc -l $fout $sout $pout

