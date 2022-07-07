import random
import csv
import math
import sys
from pathlib import PurePath
from pathlib import Path

indir=sys.argv[1]
dy_dir=sys.argv[2]
fp_dir=sys.argv[3]

pathlist = Path(indir).rglob('*merged.bed')
for path in pathlist:
	file = str(path)
	info = PurePath(file).stem
	name = info.split('_')[0]
	type = info.split('_')[1]
	mv = info.split('_')[-2]
	pref = str(name + '_' + type) #prefix for naming outputs consisting of name_type
	up_down = int(mv)/2
	dy_out = str(dy_dir + '/' + pref + '_all_' + mv + '_dyads.bed')
	fp_out = str(fp_dir + '/' + pref + '_all_' + mv + '_fps.bed')
	with open(file) as mix:
		values = csv.reader(mix, delimiter = '\t')
		a = list(values)
		print(str(len(a)) + ' input intervals')
		dy = open(dy_out, 'w+')
		fp = open(fp_out, 'w+')
		for i in range(len(a)):
			e = a[i]
			chr = e[0]
			m_p = math.floor(int(e[2]) - (((int(e[2])) - (int(e[1])))/2))
			if up_down <= m_p:
				b_v = str(int(m_p - up_down))
				a_v = str(int(m_p + up_down))
			else:
				b_v = str(0)
				a_v = str(int(m_p*2))
				print(str('Negative entry detected, adjusted to 0 at boundary - region dyad is within ' + str(up_down) + ' of chr end'))
			dy.write(chr)
			dy.write('\t')
			dy.write(str(m_p))
			dy.write('\t')
			dy.write(str(m_p + 1))
			dy.write('\t')
			dy.write(str(name + '_' + mv + '_dyad_' + str(i + 1)))
			dy.write('\n')

			fp.write(chr)
			fp.write('\t')
			fp.write(str(b_v))
			fp.write('\t')
			fp.write(str(a_v))
			fp.write('\t')
			fp.write(str(name + '_' + mv + '_fp_' + str(i + 1)))
			fp.write('\n')
	dy.close()
	fp.close()
	mix.close()
	#print('Merged BED converted to dyads and intervals')
print(str('All BED files converted to dyads and intervals'))
exit
