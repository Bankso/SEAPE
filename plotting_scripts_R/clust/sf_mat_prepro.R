#This processes SF binding signal into a scaled matrix with the bed entries
#Requires a list of three matrices from timepoints of SpLiT-ChEC small frag signal
#Be sure to enter dimensions
#Data frames built in this program are used by rel_data_clustering.R

matlist <- input_list
regsize <- region_size
cval <- mat_center

reg1 <- as.character(cval - (regsize/2))
reg2 <- as.character(cval + (regsize/2))
nfr <- c(reg1:reg2)

trimlist <- mtrim(matlist, nfr)

names <- trimlist[[1]]
nmat <- do.call(rbind, names)

vals <- trimlist[[2]]
raw_binding <- lapply(vals, rowMeans)

matinfo <- lapply(raw_binding, describe)
