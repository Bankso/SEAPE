import random
import csv
import math
import sys
from pathlib import PurePath
from pathlib import Path

peak_set = str(sys.argv[1]) # 'all' or 'unique' peak types
prot_list = list(sys.argv[2:]) # Root names for directories following the required format

for prot in prot_list:
	if peak_set == 'all':
		end_list = ('all_sf/', 'all_ff/')

	if peak_set == 'unique':
		end_list = ('sf/', 'ff/')
	
	dt_list = (str(prot + '/merging_analysis/mixed_intervals/' + end_list[0]), str(prot + '/merging_analysis/mixed_intervals/' + end_list[1])) # 
	c = len(dt_list) # 2, a constant here, but maybe scaled up later
	for i in range(c):
		end = end_list[i]
		dt = dt_list[i]
		dy_dir = str(prot + '/merging_analysis/footprint_dyads/' + end) 
		fp_dir = str(prot + '/merging_analysis/full_print_regions/' + end)
		in_parts = PurePath(dt).parts
		name_list = [in_parts[0], in_parts[-1]]
		sep = '_'
		name = sep.join(name_list)

		pathlist = Path(dt).rglob('*.bed.merged')
		for path in pathlist:
			file = str(path)
			info = PurePath(file).stem
			premv = info.split('_')[-1]
			mv = premv.split('.')[0]
			up_down = int(mv)
			dy_out = str(dy_dir + '/' + name + '_' + mv + '_dyads.bed')
			fp_out = str(fp_dir + '/' + name + '_' + mv + '_fps.bed')
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
			print('Merged BED ' + prot + ' ' + str(mv) + ' converted to dyads and intervals')
print(str('All BED files converted for ' + prot))
exit
