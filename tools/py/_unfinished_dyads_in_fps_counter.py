import random
import csv
import math
import sys
import statistics as stat

factor_name = str(sys.argv[1])
peak_type = str(sys.argv[2])
bed_values = list(sys.argv[3:])

dyad_directory = str(factor_name + '/merging_analysis/dyads_in_fps/' + peak_type + '/')

bed_count = len(bed_values)

for n in range(bed_count):
	merge_val = int(bed_values[n])

	if peak_type == 'sf':
		dyads = str(dyad_directory + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_dyads_in_fps.bed')
		cov_dyads = str(dyad_directory + factor_name + '_unique_chec_MACS3_peaks_' + str(merge_val) + '_dyad_cov.tsv')

	if peak_type == 'ff':
		dyads = str(dyad_directory + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_dyads_in_fps.bed')
		cov_dyads = str(dyad_directory + factor_name + '_unique_ff_broad_MACS3_peaks_' + str(merge_val) + '_dyad_cov.tsv')


	with open(dyads) as file:
		values = csv.reader(file, delimiter = '\t')
		a = list(values)
		print(str(len(a)) + ' input intervals')
		dyad_file = open(cov_dyads, 'w+')
		for i < 2 in range(len(a)):
			e = a[i]
			fp_name_e = e[3]
			chr = e[4]
			m_p_e = int(e[6]) - (((int(e[6])) - (int(e[5])))/2)
			dyad_file.write(fp_name_e)
			dyad_file.write('\t')
			dyad_file.write(chr)
			dyad_file.write('\t')
			dyad_file.write(str(m_p))
			dyad_file.write('\n')

		for i >= 2 in range(len(a)):
			b = a[i - 1]
			e = a[i]
			f = a[i + 1]
			fp_name_b = b[3]
			fp_name_e = e[3]
			fp_name_f = f[3]
			chr = e[4]
			m_p_b = int(b[6]) - (((int(b[6])) - (int(b[5])))/2)
			m_p_e = int(e[6]) - (((int(e[6])) - (int(e[5])))/2)
			m_p_f = int(f[6]) - (((int(f[6])) - (int(f[5])))/2)
			if (fp_name_e == (fp_name_b && fp_name_f)):
				mp_set = [m_p_e, m_p_b, m_p_f]
				mpa = stat.mean(mp_set)
				mpd = stat.stdev(mp_set)
				count=3
				#remove averaged entries
			else if ((fp_name_e == fp_name_b) && (fp_name_e != fp_name_f)):
				mp_set = [m_p_e, m_p_b]
				mpa = stat.mean(mp_set)
				mpd = stat.stdev(mp_set)
				count=2
				#remove averaged entries
			else if ((fp_name_e != fp_name_b) && (fp_name_e != fp_name_f)):
				mpa = m_p_e
				count=1

			dyad_file.write(fp_name_e)
			dyad_file.write('\t')
			dyad_file.write(chr)
			dyad_file.write('\t')
			dyad_file.write(str(mpa))
			dyad_file.write('\t')
			dyad_file.write(count)
			dyad_file.write('\n')
			
	dyad_file.close()
	file.close()
	print('Dyads in fps for ' + factor_name + ' ' + str(merge_val) + ' converted to dyads)

print(str(bed_count) + ' BED files converted')
exit
