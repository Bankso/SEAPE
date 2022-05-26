import random
import csv
import math
import sys

in_bed = sys.argv[1]
b_in = int(sys.argv[2])
a_in = int(sys.argv[3])
out_name = sys.argv[4]

fast_bed = open(out_name, 'w+')

with open(in_bed) as file:
    values = csv.reader(file, delimiter = '\t')
    a = list(values)
    print(len(a))
    for i in range(len(a)):
	e = a[i]
	n = e[0]
	m_p = int(e[2]) - (((int(e[2])) - (int(e[1])))/2)
	if b_in <= m_p:
		b_v = str(m_p - b_in)
	else:
		b_v = str(0)
	a_v = str(m_p + a_in)
	fast_bed.write(n)
	fast_bed.write('\t')
	fast_bed.write(b_v)
	fast_bed.write('\t')
	fast_bed.write(a_v)
	fast_bed.write('\t')
	fast_bed.write('\t')
	fast_bed.write(e[4])
	fast_bed.write('\n')
            
fast_bed.close

print('BED strand info copied and bounds adjusted to requested range')
