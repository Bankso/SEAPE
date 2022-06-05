import random
import csv
import math
import sys
from pathlib import Path

'''
'''

dyads = sys.argv[1]
outdir = sys.argv[2]
strand = sys.argv[3]
sizes = list(sys.argv[4:])

out_name = Path(dyads).stem
out_root = str(outdir + '/' + out_name)
sep = '_'
name_list = out_name.split(sep)[0:2]
name = sep.join(name_list)

print('Converting dyads to ' + str(len(sizes)) + ' interval(s)')
for s in sizes:
	bed_name = str(out_root + '_' + str(2*int(s)) + '.bed')
	new_bed = open(bed_name, 'w+')
	with open(dyads) as file:
		values = csv.reader(file, delimiter = '\t')
		a = list(values)
		for i in range(len(a)):
			v = int(s)
			e = a[i]
			chr = e[0]
			m_p = int(e[2])
			if v <= m_p:
				b_v = str(m_p - v)
				a_v = str(m_p + v)
			else:
				b_v = str(0)
				a_v = str(m_p*2)
				print('Negative entry detected and fixed')
			
			new_bed.write(chr)
			new_bed.write('\t')
			new_bed.write(b_v)
			new_bed.write('\t')
			new_bed.write(a_v)
			new_bed.write('\t')
			new_bed.write(str(name + '_' + str(2*int(s)) + '_site_' + str(i + 1)))
			new_bed.write('\t')
			if strand == 'TRUE':
				new_bed.write(e[4])
				new_bed.write('\n')
			else:
				new_bed.write('\n')
	new_bed.close
	file.close

print('Dyads converted to BED intervals from requested ranges')
