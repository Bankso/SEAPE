#FCGR conversion of NFR sequences IDd in SpLiT-ChEC
library(stringr)

seq <- in_fa

mseq <- read.delim(seq, header = FALSE, sep = '\n') # Read in data
jseq <- mseq %>% filter(!grepl('>', V1)) # Remove FASTA headers
lseq <- as.list(jseq$V1)
fcgr_set <- lapply(lseq, cgr, seq.base = "DNA", res = 100)
cgr.plot(fcgr_set, mode = "matrix")

