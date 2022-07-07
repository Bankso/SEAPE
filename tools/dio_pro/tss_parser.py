import random
import csv
import math
import sys

tss_file = sys.argv[1]
out_name = sys.argv[2]

new_bed = open(out_name, 'w+')

with open(tss_file) as file:
	values = csv.reader(file, delimiter = '\t')
	a = list(values)
	for i in range(1, (len(a))):
		e = a[i]
		chr = e[1].split('chr')
		val = chr[1]
		new_bed.write(val)
		new_bed.write('\t')
		new_bed.write(e[2])
		new_bed.write('\t')
		new_bed.write(e[3])
		new_bed.write('\t')
		new_bed.write(e[0])
		new_bed.write('\t')
		new_bed.write(e[6])
		new_bed.write('\t')
		new_bed.write(e[4])
		new_bed.write('\n')
new_bed.close
