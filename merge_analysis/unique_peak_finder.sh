#!/usr/bin/bash

module load bedtools

bedtools intersect -a $1 -b $2 -v > inter_file.bed
cat $2 inter_file.bed|sort -k1,1 -k2,2n > merged_1_sorted.bed
bedtools intersect -a $3 -b merged_1_sorted.bed -v > inter_file_2.bed
cat merged_1_sorted.bed inter_file_2.bed|sort -k1,1 -k2,2n > $4
