import random
import csv
import math
import sys
import os
from pathlib import Path

'''
Inputs are a BED format file with or without strand info, out directory, logical indicator for strand info, and sizes of BED file adjustments

Outputs are the set of new BED regions from input sizes
'''

infile = sys.argv[1] # A bed format file of dyads or regions (mp is calculated in conversion), dyads req. for calcs
outdir = sys.argv[2] # A directory for files to be placed and new directories to be made
strand = sys.argv[3] # Logical (TRUE or FALSE) input file has strand info that should be copied?
sizes = list(sys.argv[4:]) # A list of values to be used as symmetric modifiers of the "footprint" size during calcs

#os.mkdir(outdir)
out_name = Path(infile).stem
out_root = str(outdir + '/' + out_name)
sep = '_'
name_list = out_name.split(sep)[0:2]
name = sep.join(name_list)

#Build new bed regions based on input dyads and requested intervals
print('Converting regions to ' + str(len(sizes)) + ' interval(s)')
for s in sizes:
	bed_name = str(out_root + '_' + str(2*int(s)) + '.bed')
	new_bed = open(bed_name, 'w+')
	with open(infile) as file:
		values = csv.reader(file, delimiter = '\t')
		a = list(values)
		for i in range(len(a)):
			v = int(s)
			e = a[i]
			chr = e[0]
			m_p = math.floor(int(int(e[2]) - ((int(e[2]) - int(e[1]))/2)))
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
			new_bed.write(' ')
			if strand == 'TRUE':
				new_bed.write('\t')
				new_bed.write(e[4])
				new_bed.write('\n')
			else:
				new_bed.write('\n')
	new_bed.close
	file.close

print('Dyads converted to BED intervals from requested ranges')
