#!/opt/conda/envs/SCAR_env/bin/Rscript

library('data.table') 
library('gtools')

env_vars <- Sys.getenv(c('input', 'out'), names=TRUE)

in_file <- env_vars[['input']]
out_name <- env_vars[['out']]

regions <- read.delim(in_file, header = FALSE, sep = '\t')

bed_entries <- regions[3:6]

names(bed_entries) <- c('chr', 'up', 'down', 'strand')

print(bed_entries)

sorted_chrs <- mixedsort(bed_entries[['chr']], numeric.type = 'roman', roman.case = 'upper')
order_chrs <- mixedorder(bed_entries[['chr']], numeric.type = 'roman', roman.case = 'upper')

print(sorted_chrs)
print(bed_entries['chr'])

sorted_chrs <- data.table(sorted_chrs)
names(sorted_chr) <- 'ch_srt'

sorted_bed <- match(sorted_chrs, bed_entries$chr)

print(sorted_bed)

chr_list <- sorted_bed['chr']

chr_num <- split(chr_list, 'chr')
print(chr_num)
chr_num <- chr_num[2]
#chr_num <- sapply(chr_num, as.roman)

sorted_bed['chr'] <- chr_num 

write.table(sorted_bed, out_name, quote=FALSE, sep='\t', row.names=FALSE, col.names=FALSE)