#!/usr/bin/bash

bedtools intersect -a $1 -b $2 -u > $3
