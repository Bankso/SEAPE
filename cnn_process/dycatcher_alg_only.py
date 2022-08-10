import random
import csv
import math
import sys
from pathlib import PurePath
from pathlib import Path

all_dyads = sys.argv[1] #input path for a BED of all MACS3 dyads, need to add a broad flag and condition to adjust range
type = sys.argv[2] # a short label for the output dyads
max_dy = int(sys.argv[3]) #max number of dyads to search for per entry
max_list = list(sys.argv[4:]) #list of max distances

def sort_key(line): #A key to feed to the sort function that acts like bash sort
	fields = line.split()
	try:
		return fields[0], int(fields[1]), int(fields[2])
	except (IndexError, ValueError):
		return () # sort invalid lines together

dir_parts = PurePath(all_dyads).parts
mpname = ('_').join([dir_parts[0], type, 'all_dyads_sorted_merged.tsv'])
mpout = str(dir_parts[0] + '/merging_analysis/raw_dyads/' + mpname)
	
with open(all_dyads) as dyads:	
	values = csv.reader(dyads, delimiter = '\t')
	a = list(values)
	mpset = open(mpout, 'w+')
	for i in range(1, len(a) - 1):
		for max in max_list:
			k = 1 #set the dyad counter - if we are reading an entry, there is one dyad already
			xc = 0 #extension counter - marks how far we've moved to find a neighbor dyad
			while k <= max_dy: #limit searching to a number of dyads found
				dc = a[i] #current dyad
				chrc = dc[0] #chr number of current dyad
				db = a[i - 1] #dyad before current
				chrb = db[0]
				da = a[i + 1] #dyad after current
				chra = da[0]
				if xc < int(max):

					if chrc == chra and chrc == chrb: #all entries on same chromosome
						if dc[1] <= db[2] and dc[2] >= da[1]: #overlap on both ends, define new dyad
							k = k + 2
							dm1 = math.floor(int(da[2]) - (((int(da[2])) - (int(db[1])))/2))
							dm2 = dm1 + 1
							continue

						elif dc[1] <= db[2] and dc[2] < da[1]: #overlap on left end only, define new dyad, extend right side
							k = k + 1
							xc = xc + 1
							dm1 = math.floor(int(dc[2]) - (((int(dc[2])) - (int(db[1])))/2))
							dm2 = dm1 + xc
							continue

						elif dc[1] > db[2] and dc[2] >= da[1]: #overlap on right end only, define new dyad, extend left side
							k = k + 1
							xc = xc + 1
							dm2 = math.floor(int(da[2]) - (((int(da[2])) - (int(dc[1])))/2))
							dm1 = dm2 - xc
							continue

						else: # no overlap, but we know neighbors are on same chr
							xc = xc + 1
							dm1 = int(dc[2]) + xc
							dm2 = int(dc[2]) - xc
							continue

					if chrc == chrb or chrc == chra: #current entry on same chr as one neighbor

						if dc[1] <= db[2] and chrc != chra: # left match - don't add to right
							k = k + 1
							dm1 = math.floor(int(dc[2]) - (((int(dc[2])) - (int(db[1])))/2))
							dm2 = dm1 + 1
							continue
						
						elif dc[2] >= da[1] and chrc != chrb: # right match - don't add to left
							k = k + 1
							dm1 = math.floor(int(da[2]) - (((int(da[2])) - (int(dc[1])))/2))
							dm2 = dm1 + 1
							continue

						else: #no overlap, but we know one neighbor could be matched still
							xc = xc + 1
							if chrc == chrb: #if previous entry is on chr
								dm2 = int(dc[2])
								dm1 = dm2 - xc
								continue

							if chrc == chra: #if next entry is on chr
								dm1 = int(dc[1])
								dm2 = dm1 + xc
								continue

							else: #no matches left on chromosome for current dyad
								print('No dyads left on chromosome within maximum range for current dyad limit')
								break

		mpset.write(chrc)
		mpset.write('\t')
		mpset.write(str(dm1))
		mpset.write('\t')
		mpset.write(str(dm2))
		mpset.write('\t')
		mpset.write(str(dir_parts[0] + '_' + str(type) + '_region_' + str(i)))
		mpset.write('\t')
		mpset.write(str(max))
		mpset.write('\t')
		mpset.write(str(k))
		mpset.write('\n')
mpset.close()
