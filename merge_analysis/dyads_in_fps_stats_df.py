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
dyad_directory = str(factor_name + '/merging_analysis/' + peak_set + '/dyads_in_fps/' + peak_type)
out_root = str(dyad_directory + '/stats/' + factor_name + '_' + peak_type + '_fp_dyad_')
bed_count = len(bed_values)

for n in range(bed_count):
	merge_val = int(bed_values[n])

	if peak_type == 'sf':
		dyads = str(dyad_directory + '/' + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed_dyad_sets.tsv')

	if peak_type == 'ff':
		dyads = str(dyad_directory + '/' + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed_dyad_sets.tsv')

	info_out = str(out_root + str(merge_val))
	info_out_a = str(info_out + '_avgs.tsv')
	info_out_x = str(info_out + '_max.tsv')
	info_out_n = str(info_out + '_min.tsv')
	info_out_s = str(info_out + '_all_val.tsv')
	dyads_df = pd.read_table(dyads, delimiter='\t', names=('fp_chr','fp_1','fp_2','fp_n','mp_chr','mp_1','mp_2','mp_n','c'))
	mpa_info = dyads_df.iloc[:, [3, 4, 5]]
	mean_mpa = mpa_info.groupby(by='fp_n',sort=False).mean()
	max_mpa = mpa_info.groupby(by='fp_n',sort=False).max()
	min_mpa = mpa_info.groupby(by='fp_n',sort=False).min()
	mean_mpa.to_csv(str(info_out_a), sep='\t')
	max_mpa.to_csv(str(info_out_x), sep='\t')
	min_mpa.to_csv(str(info_out_n), sep='\t')

	all_stats = open(info_out_s, 'w+')
	
	entries = open(info_out_a)
	entry_values = csv.reader(entries, delimiter = '\t')
	entry_list = list(entry_values)
	entries.close

	for i in range(1, len(entry_list)):
		with open(info_out_n) as file1:
			values1 = csv.reader(file1, delimiter = '\t')
			a = list(values1)
			e = a[i]
			all_stats.write(e[0])
			all_stats.write('\t')
			all_stats.write(e[1])
			all_stats.write('\t')
			all_stats.write(e[2])
			all_stats.write('\t')

		with open(info_out_x) as file2:
			values2 = csv.reader(file2, delimiter = '\t')
			b = list(values2)
			f = b[i]
			all_stats.write(f[2])
			all_stats.write('\t')
			
		with open(info_out_a) as file3:
			values3 = csv.reader(file3, delimiter = '\t')
			c = list(values3)
			g = c[i]
			all_stats.write(g[1])
			all_stats.write('\n')
	file1.close
	file2.close
	file3.close
	all_stats.close
	print('Summary file printed for stats')
