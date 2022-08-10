import random
import csv
import math
import sys
from pathlib import PurePath
from pathlib import Path

peaks_xls = list(sys.argv[1:3]) #input paths for a raw MACS3 peaks file set, need to add a broad flag and condition to adjust range
max_dy = int(sys.argv[4]) #max number of dyads to search for per entry
max_list = list(sys.argv[5:]) #list of max distances to limit merging by

def sort_key(line): #A key to feed to the sort function that acts like bash sort
    fields = line.split()
    try:
        return fields[0], int(fields[1]), int(fields[2])
    except (IndexError, ValueError):
        return () # sort invalid lines together

for rpf in peaks_xls:
    dir_parts = PurePath(rpf).parts
    name_list = [dir_parts[0], dir_parts[1], dir_parts[-3]]
    sep = '_'
    name = sep.join(name_list)
    bed_name = ().join(c(name, '.bed'))
    dyads_name = ().join(c(name, '_dyads.bed'))
    out_bed = str(dir_parts[0] + '/merging_analysis/raw_peaks/' + bed_name)
    out_dyads = str(dir_parts[0] + '/merging_analysis/raw_peaks/' + dyads_name)
    dyads_list = list()
    dyads_list.append(out_dyads) #keeps track of the dyads files made for later processing
    new_bed = open(out_bed, 'w+')
    new_dyads = open(out_dyads, 'w+')
    with open(rpf) as file:
        values = csv.reader(file, delimiter = '\t')
        a = list(values)
        print(len(a) - 23)
        for i in range(23, (len(a))):
	           e = a[i]
               chr = e[0]
               m_p = math.floor(int(e[2]) - (((int(e[2])) - (int(e[1])))/2))
	           new_bed.write(chr)
	           new_bed.write('\t')
	           new_bed.write(e[1])
	           new_bed.write('\t')
	           new_bed.write(e[2])
	           new_bed.write('\t')
	           new_bed.write(e[9])
	           new_bed.write('\n')

               dy.write(chr)
               dy.write('\t')
               dy.write(str(m_p))
               dy.write('\t')
               dy.write(str(m_p + 1))
               dy.write('\t')
               dy.write(str(name + '_dyad_' + str(i - 22)))
               dy.write('\n')

print('BED and dyads files made from peaks XLS')
print('Continuing processing with ' + str(len(dyads_list)) ' dyad sets')

dir_parts = PurePath(peaks_xls[0]).parts
name_all_dy = ().join(c(dir_parts[0], dir_parts[-3], '_all_dyads.bed'))
name_all_dy_s = ().join(c(dir_parts[0], dir_parts[-3], '_all_dyads_sorted.bed'))
all_dy = str(dir_parts[0] + '/merging_analysis/raw_peaks/' + name_all_dy)
srt_all_dy = str(dir_parts[0] + '/merging_analysis/raw_peaks/' + name_all_dy_s)

with open(all_dy, 'w+') as outfile:
    for dy in dyads_list:
        with open(dy) as addfile:
            for line in addfile:
                all_dy.write(line)

	all_dy.sort(key=sort_key)

	with open(srt_all_dy, 'wb') as sortfile:
        sortfile.writelines(all_dy)

print('Dyads combined and sorted for merge analysis')

mpname = ().join(c(dir_parts[0], dir_parts[-3], '_all_dyads_sorted_merged.tsv'))
mpout = str(dir_parts[0] + '/merging_analysis/raw_peaks/' + mpname)

with open(srt_all_dy, 'r') as alldyads:
	mpset = open(mpout, 'w+')
    values = csv.reader(alldyads, delimiter = '\t')
    a = list(values)
    print(len(a))
	for i in range(1, (len(a) - 1))):
		for max in max_list:
			k = 1 #set the dyad counter - if we are reading an entry, there is one dyad already
			xc = 0 #extension counter - marks how far we've moved to find a neighbor dyad
			while k <= max_dy: #limit searching to a number of dyads found
				if xc < max:
					dc = a[i] #current dyad
            		chrc = dc[0] #chr number of current dyad
            		db = a[i - 1] #dyad before current
            		chrb = db[0]
            		da = a[i + 1] #dyad after current
            		chra = da[0]

					if chrc == chra and chrc == chrb: #all entries on same chromosome

                		if dc[1] <= db[2] and dc[2] >= da[1]: #overlap on both ends, define new dyad
                    		k = k + 2
                    		dm1 = math.floor(int(da[2]) - (((int(da[2])) - (int(db[1])))/2))
                    		dm2 = dm1 + 1

                		elif dc[1] <= db[2] and dc[2] < da[1]: #overlap on left end only, define new dyad, extend right side
                    		k = k + 1
                    		xc = xc + 1
                    		dm1 = math.floor(int(dc[2]) - (((int(dc[2])) - (int(db[1])))/2))
                    		dm2 = dm1 + xc

                		elif dc[1] > db[2] and dc[2] >= da[1]: #overlap on right end only, define new dyad, extend left side
                    		k = k + 1
                    		xc = xc + 1
                    		dm2 = math.floor(int(da[2]) - (((int(da[2])) - (int(dc[1])))/2))
                    		dm1 = dm2 - xc

                		else: # no overlap, but we know neighbors are on same chr
                    		xc = xc + 1
                        	dm1 = int(dc[2]) + xc
                        	dm2 = int(dc[2]) - xc

					if chrc == chrb or chrc == chra: #current entry on same chr as one neighbor

                    	if dc[1] <= db[2] and chrc != chra: # left match - don't add to right
                			k = k + 1
                			dm1 = math.floor(int(dc[2]) - (((int(dc[2])) - (int(db[1])))/2))
                			dm2 = dm1 + 1

            			elif dc[2] >= da[1] and chrc != chrb: # right match - don't add to left
                			k = k + 1
                			dm1 = math.floor(int(da[2]) - (((int(da[2])) - (int(dc[1])))/2))
                			dm2 = dm1 + 1

            			else: #no overlap, but we know one neighbor could be matched still
							xc = xc + 1
							if chrc == chrb: #if previous entry is on chr
                        		dm2 = int(dc[2])
                        		dm1 = dm2 - xc

							if chrc == chra: #if next entry is on chr
                        		dm1 = int(dc[1])
                        		dm2 = dm1 + xc

        			else: #no matches left on chromosome for current dyad
            			print('No dyads left on chromosome within maximum range for current dyad limit')
						break

		mpset.write(chrc)
		mpset.write('\t')
		mpset.write(str(dm1))
		mpset.write('\t')
        mpset.write(str(dm2))
		mpset.write('\t')
		mpset.write(str(dir_parts[0] + '_' + dir_parts[-3] + '_region_' + i))
		mpset.write('\t')
		mpset.write(str(max))
		mpset.write('\t')
		mpset.write(str(k))
		mpset.write('\n')
mpset.close()
