import random
import csv
import math
import sys
import numpy as np
import pandas as pd
from pathlib import PurePath
from pathlib import Path

counts = sys.argv[1]
outdir = sys.argv[2]

out_name = PurePath(counts).parts
name_list = [out_name[0], out_name[-2]]
sep = '_'
name = sep.join(name_list)
hist_out = str(outdir + '/' + name + '_hist_summary.tsv')
f = open(hist_out, 'w+')

pathlist = Path(counts).rglob('*.counts')
for path in pathlist:
	file = str(path)
	info = PurePath(file).stem
	end = info.split('_')[-1]
	val = end.split('.')[0]
	with open(file) as in_set:
		for line in in_set:
			a = line.split()
			f.write(str(val))
			f.write('\t')
			f.write(str(a[5]))
			f.write('\n')
f.close()

print('Counts for histogram compiled to row vectors')
