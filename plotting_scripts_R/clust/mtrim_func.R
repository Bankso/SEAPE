mtrim <- function(matlist, nfr) {
	mats <- lapply(matlist, read.delim, header=FALSE) #Read in matrices as data frames
	fixmats <- lapply(mats, na.omit) #Remove NAs if present, replaced with 0
	namemats <- lapply(fixmats, subset.data.frame, select=c(0:4, 5)) #cut the names and keep
	valmats <- lapply(fixmats, subset.data.frame, select=nfr) #cut the NFR values and keep
	return(list(namemats, valmats)) #store names and values
}

