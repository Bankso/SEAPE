import random
import csv
import math
import sys

links_file = sys.argv[1]
out_name = sys.argv[2]

new_bed = open(out_name, 'w+')

with open(links_file) as file:
	values = csv.reader(file, delimiter = '\t')
	a = list(values)
	for i in range(1, (len(a))):
		e = a[i]
		entry = e[3].split(':')
		val = entry[0]
		bounds = entry[1].split('-')
		b1 = int(bounds[0]) - 1
		b2 = bounds[1]
		st = e[2]

		new_bed.write(val)
		new_bed.write('\t')
		new_bed.write(str(b1))
		new_bed.write('\t')
		new_bed.write(b2)
		new_bed.write('\t')
		new_bed.write(e[3])
		new_bed.write('\t')
		new_bed.write(e[4])
		new_bed.write('\t')
		new_bed.write(st)
		new_bed.write('\n')
new_bed.close
