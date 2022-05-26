#!/usr/bin/bash
 
if [ $2 == ff ] ; then
merge_file=$1/merging_analysis/full_print_regions/$1_unique_ff_broad_MACS3_peaks_$3_merged_footprints.bed 
dyads=$1/merging_analysis/raw_dyads/$1_unique_ff_broad_MACS3_peaks_dyads.bed
out_name=$1/merging_analysis/dyads_in_fps/$1_unique_ff_broad_MACS3_peaks_$3_dyads_in_fps.bed
echo $merge_file
echo $dyads
echo $out_name
bedtools intersect -a $merge_file -b $dyads -wo > $out_name
bedtools intersect -a $merge_file -b $dyads -c > $out_name.counts
elif [ $2 == sf ] ; then
merge_file=$1/merging_analysis/full_print_regions/$1_unique_chec_MACS3_peaks_$3_merged_footprints.bed
dyads=$1/merging_analysis/raw_dyads/$1_unique_chec_MACS3_peaks_dyads.bed
out_name=$1/merging_analysis/dyads_in_fps/$1_unique_chec_MACS3_peaks_$3_dyads_in_fps.bed
echo $merge_file
echo $dyads
echo $out_name
bedtools intersect -a $merge_file -b $dyads -wo > $out_name
bedtools intersect -a $merge_file -b $dyads -c > $out_name.counts
fi

