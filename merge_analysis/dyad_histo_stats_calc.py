import random
import csv
import math
import sys
import numpy as np
import pandas as pd

factor_name = str(sys.argv[1])
peak_set = str(sys.argv[2])
peak_type = str(sys.argv[3])
bed_values = list(sys.argv[4:])
bed_count = int(len(bed_values))
dyad_directory = str(factor_name + '/merging_analysis/' + peak_set + '/can_sites/' + peak_type + '/counts')
out_root = str(dyad_directory + '/hist_outs/' + factor_name + '_' + peak_type + '_can_dyads_in_fps_hist_vals.tsv')

dyads_set = []

for n in range(bed_count):
	merge_val = int(bed_values[n])
	if peak_type == 'sf':
		dyads = str(dyad_directory + '/' + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed_dyad.counts')

	if peak_type == 'ff':
		dyads = str(dyad_directory + '/' + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed_dyad.counts')
	
	dyads_set.append(dyads)

print(len(dyads_set))
#print(dyads_set)
#newlines = []
#run_set = []
#outlines = []
f = open(out_root, 'w+')

for file in dyads_set[:]:
	with open(file) as in_set:
		for line in in_set:
			a = line.split()
			f.write(str(a[4]))
			f.write('\t')
	f.write('\n')

#for file_b in dyads_set[1:]:
#	with open(file_b) as in_set_b:
#		for line in in_set_b:
#			b = line.split()
#			f.write('\t')
#			f.write(str(b[4]))
#			f.write('\n')
f.close()

print('Counts for histogram compiled')
