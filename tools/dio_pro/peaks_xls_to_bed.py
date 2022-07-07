import random
import csv
import math
import sys

peaks_xls = sys.argv[1]
out_name = sys.argv[2]

new_bed = open(out_name, 'w+')

with open(peaks_xls) as file:
	values = csv.reader(file, delimiter = '\t')
	a = list(values)
	print(len(a) - 23)
	for i in range(23, (len(a))):
		e = a[i]
		new_bed.write(e[0])
		new_bed.write('\t')
		new_bed.write(e[1])
		new_bed.write('\t')
		new_bed.write(e[2])
		new_bed.write('\t')
		new_bed.write(e[9])
		new_bed.write('\n')

new_bed.close

print('BED file made from peaks XLS')
