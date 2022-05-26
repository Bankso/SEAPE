import random
import csv
import math
import sys

factor_name = str(sys.argv[1])
sort_set = str(sys.argv[2])
peak_type = str(sys.argv[3])
bed_values = list(sys.argv[4:])

interval_directory = str(factor_name + '/merging_analysis/' + sort_set + '/mixed_intervals/')
dyad_directory = str(factor_name + '/merging_analysis/' + sort_set + '/footprint_dyads/')
merged_directory = str(factor_name + '/merging_analysis/' + sort_set + '/full_print_regions/')

bed_count = len(bed_values)

for n in range(bed_count):
	merge_val = int(bed_values[n])
	up_down = merge_val/2

	if peak_type == 'sf':
		mixed_intervals = str(interval_directory + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '.bed.merged')
		new_dyads = str(dyad_directory + '/sf/' + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_merged_dyads.bed')
		new_fps = str(merged_directory + '/sf/' + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed')

	if peak_type == 'ff':
		mixed_intervals = str(interval_directory + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '.bed.merged')
		new_dyads = str(dyad_directory + '/ff/' + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_merged_dyads.bed')
		new_fps = str(merged_directory + '/ff/' + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_merged_footprints.bed')

	with open(mixed_intervals) as file:
		values = csv.reader(file, delimiter = '\t')
		a = list(values)
		print(str(len(a)) + ' input intervals')
		fp_file = open(new_fps, 'w+')
		dyad_file = open(new_dyads, 'w+')
		for i in range(len(a)):
			e = a[i]
			chr = e[0]
			m_p = math.floor(int(e[2]) - (((int(e[2])) - (int(e[1])))/2))
			if up_down <= m_p:
				b_v = str(int(m_p - up_down))
				a_v = str(int(m_p + up_down))
			else:
				b_v = str(0)
				a_v = str(int(m_p*2))
				print('Negative entry detected and fixed')

			dyad_file.write(chr)
			dyad_file.write('\t')
			dyad_file.write(str(m_p))
			dyad_file.write('\t')
			dyad_file.write(str(m_p + 1))
			dyad_file.write('\t')
			dyad_file.write(str(factor_name + '_' + peak_type + '_dyad_' + str(i + 1)))
			dyad_file.write('\n')
			fp_file.write(chr)
			fp_file.write('\t')
			fp_file.write(str(b_v))
			fp_file.write('\t')
			fp_file.write(str(a_v))
			fp_file.write('\t')
			fp_file.write(str(factor_name + '_' + peak_type + '_fp_' + str(i + 1)))
			fp_file.write('\n')
	dyad_file.close()
	fp_file.close()
	file.close()
	print('Merged BED ' + factor_name + ' ' + str(merge_val) + ' converted to dyads and intervals')
print(str(bed_count) + ' BED files converted')
exit
