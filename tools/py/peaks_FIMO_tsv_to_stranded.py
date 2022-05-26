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
    for i in range(1, (len(a) - 4)):
	e = a[i]
	n = e[2].split(':')
	nme = n[0]
	o_d = n[1].split('-')[0]

	new_bed.write(nme)
	new_bed.write('\t')
	new_bed.write(str(int(o_d) + int(e[3])))
	new_bed.write('\t')
	new_bed.write(str(int(o_d) + int(e[4])))
	new_bed.write('\t')
	new_bed.write('\t')
	new_bed.write(e[5])
	new_bed.write('\n')
            
new_bed.close

print('BED file made from TSV with ' + str((len(a)-4)) + ' entries')

	
	

