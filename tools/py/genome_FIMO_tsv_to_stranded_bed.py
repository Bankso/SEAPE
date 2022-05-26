import random
import csv
import math
import sys

fimo_tsv = sys.argv[1]
out_name = sys.argv[2]

new_bed = open(out_name, 'w+')

with open(fimo_tsv) as file:
    values = csv.reader(file, delimiter = '\t')
    a = list(values)
    print(len(a) - 4)
    for i in range(1, (len(a) - 4)):
	e = a[i]
	n = e[2]
	new_bed.write(n[3:])
	new_bed.write('\t')
	new_bed.write(e[3])
	new_bed.write('\t')
	new_bed.write(e[4])
	new_bed.write('\t')
	new_bed.write('\t')
	new_bed.write(e[5])
	new_bed.write('\n')
            
new_bed.close

print('BED file made from TSV')

	
	

