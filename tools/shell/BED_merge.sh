#!/usr/bin/bash

sort -k1,1 -k2,2n $1 > sorted.bed

bedtools merge -i sorted.bed -d $2 > $3

wc -l $3
