import fileinput
import random
import csv
import math
import sys

in_bed_names = sys.argv[1]

with fileinput.input(in_bed_names) as bed_list:
	for line in bed_list as old_bed:
		split.old_bed
		if a_in - b_in <= 1:
			out_name = old_bed + 'dyads.bed'
		else:
			out_name = old_bed + '_' + b_in + '_' + a_in + '.bed'
		
		fast_bed = open(out_name, 'w+')
		old_bed = old_bed + '.bed'

		with open(old_bed) as file:
    			values = csv.reader(file, delimiter = '\t')
    			a = list(values)
    			print(len(a))
   			for i in range(len(a)):
				e = a[i]
				n = e[0]
				m_p = int(e[2]) - (((int(e[2])) - (int(e[1])))/2)
				b_v =  str(m_p - b_in)
				a_v = str(m_p + a_in)
				fast_bed.write(n)
				fast_bed.write('\t')
				fast_bed.write(b_v)
				fast_bed.write('\t')
				fast_bed.write(a_v)
				fast_bed.write('\n')
            
				fast_bed.close

				print('BED intervals adjusted to input range')
