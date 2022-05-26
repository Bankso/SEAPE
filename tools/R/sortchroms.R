#!/SCAR_env/bin/Rscript

library('data.table') 
library('gtools')

regions <- read.delim('/opt/conda/process/regions_for_plots/TBP_MAT01.bar.wig.txt', header = FALSE, sep = '\t')

names(regions) <- c('chr', 'up', 'down', 'counts')

sorted_regions <- mixedsort(regions[['chr']], numeric.type = 'decimal', roman.case = 'upper')
order_regions <- mixedorder(regions[['chr']], numeric.type = 'decimal', roman.case = 'upper')

sorted_bed <- regions[match(sorted_regions, regions$chr)]

chr_list <- sorted_regions[['chr']]

chr_num <- 

chr_list <- lapply(chr_list, function(x) split(x, 'chr')) 

write.table(sort_chr, '', quote=FALSE, sep='\t', row.names=FALSE, col.names=FALSE)

l = ['element1\t0238.94', 'element2\t2.3904', 'element3\t0139847']
>>> [i.split('\t', 1)[0] for i in l]
['element1', 'element2', 'element3']