#Calc for distance between pred NFR region centers and overlapped FIMO sites

import random
import csv
import math
import sys
from pathlib import PurePath
from pathlib import Path

inset=sys.argv[1]
outdir=sys.argv[2]

file = str(inset)
info = PurePath(file).stem
name = info.split('_')[0]
type = info.split('_')[1]
mv = info.split('_')[-4]
pref = str(name + '_' + type) #prefix for naming outputs consisting of name_type
out = str(outdir + '/' + pref + '_' + mv + '_dis_to_site.tsv')
with open(file) as mix:
	values = csv.reader(mix, delimiter = '\t')
	a = list(values)
	print(str(len(a)) + ' input intervals')
	dis = open(out, 'w+')
	for i in range(len(a)):
		e = a[i]
		chr = e[0]
		fpmp = math.floor(int(e[2]) - (((int(e[2])) - (int(e[1])))/2))
		csmp = int(e[5])
		if (csmp >= fpmp):
			dif = csmp - fpmp #Consensus sequence dyad is on the right, positive
		else:
			dif = -1*(fpmp - csmp) #Consensus sequence dyad is on the left, negative
		dis.write(chr)
		dis.write('\t')
		dis.write(str(fpmp))
		dis.write('\t')
		dis.write(str(fpmp + 1))
		dis.write('\t')
		dis.write(str(dif))
		dis.write('\t')
		dis.write(e[3])
		dis.write('\t')
		dis.write(e[8])
		dis.write('\n')

dis.close()
mix.close()
	#print('Merged BED converted to dyads and intervals')
print(str('All BED files converted to dyads and intervals'))
exit
