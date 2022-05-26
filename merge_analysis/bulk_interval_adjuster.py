import random
import csv
import math
import sys
'''
'''

name = sys.argv[1]
set = sys.argv[2]
peak_type = sys.argv[3]
sizes = list(sys.argv[4:])

dyads_dir = str(name + '/merging_analysis/' + set + '/raw_dyads/')
adj_dir = str(name + '/merging_analysis/'  + set + '/unmerged_footprints/')
dyads_type = str(name + '_unique_' + peak_type + '_MACS3_peaks_dyads.bed')
adj_type = str(name + '_unique_' + peak_type + '_MACS3_peaks_')
dyads = str(dyads_dir + dyads_type)
adj_loc = str(adj_dir + adj_type)
print('Converting dyads to ' + str(len(sizes)) + ' interval(s)')
for s in sizes:
	adj_out = str(adj_loc + str(2*int(s)) + '.bed')
	adj_bed = open(adj_out, 'w+')
	with open(dyads) as file:
		values = csv.reader(file, delimiter = '\t')
		a = list(values)
		for i in range(len(a)):
			v = int(s)
			e = a[i]
			n = e[0]
			m_p = math.floor(int(e[2]) - (((int(e[2])) - (int(e[1])))/2))
			if v <= m_p:
				b_v = str(m_p - v)
				a_v = str(m_p + v)
			else:
				b_v = str(0)
				a_v = str(m_p*2)
				print('Negative entry detected and fixed')
			adj_bed.write(n)
			adj_bed.write('\t')
			adj_bed.write(b_v)
			adj_bed.write('\t')
			adj_bed.write(a_v)
			adj_bed.write('\t')
			adj_bed.write(e[3])
			adj_bed.write('\n')
	adj_bed.close
	file.close

print('Dyads converted to BED intervals from requested ranges')
