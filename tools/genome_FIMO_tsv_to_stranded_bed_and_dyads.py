import random
import csv
import math
import sys
import os
from pathlib import PurePath
from pathlib import Path

indir = sys.argv[1] #Directory of FIMO sites tsv files to convert to BED regions and dyads
outdir = sys.argv[2]

pathlist = Path(indir).rglob('*.tsv')
for file in pathlist:
	out_root = PurePath(file).stem
	out_name = str(outdir + '/' + out_root + '.bed')
	out_dyads = str(outdir + '/' + out_root + '_dyads.bed')
	new_bed = open(out_name, 'w+')
	new_dyads = open(out_dyads, 'w+')
	with open(file) as in_reg:
		values = csv.reader(in_reg, delimiter = '\t')
		a = list(values)
		print(len(a) - 4)
		for i in range(1, (len(a) - 4)):
			e = a[i]
			n = e[2]
			m_p = math.floor(int(e[4]) - (((int(e[4])) - (int(e[3])))/2))
			d_1 =  str(m_p)
			d_2 = str(m_p + 1)
			new_bed.write(n)
			new_bed.write('\t')
			new_bed.write(e[3])
			new_bed.write('\t')
			new_bed.write(e[4])
			new_bed.write('\t')
			new_bed.write(str(out_root + '_' + str(i)))
			new_bed.write('\t')
			new_bed.write(' ')
			new_bed.write('\t')
			new_bed.write(e[5])
			new_bed.write('\n')

			new_dyads.write(n)
			new_dyads.write('\t')
			new_dyads.write(d_1)
			new_dyads.write('\t')
			new_dyads.write(d_2)
			new_dyads.write('\t')
			new_dyads.write(str(out_root + '_dyad_' + str(i)))
			new_dyads.write('\t')
			new_dyads.write(' ')
			new_dyads.write('\t')
			new_dyads.write(e[5])
			new_dyads.write('\n')
	new_bed.close
	new_dyads.close
print(str('Stranded BED and dyads file(s) made for requested FIMO TSV'))
