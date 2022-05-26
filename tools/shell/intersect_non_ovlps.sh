#!/usr/bin/bash

module load bedtools

bedtools intersect -a $1 -b $2 -v > $3
