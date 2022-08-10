mtrim <- function(matlist, reg1, reg2) {

	mats <- lapply(matlist, read.delim, header=FALSE) #Read in matrices as data frames
	mats <- lapply(mats, function(x) {x <- x[-1, ]}) #remove first row so it matches BED
	mats[is.na(mats)] <- 0

	reg1 <- as.numeric(reg1)
	reg2 <- as.numeric(reg2)

	#Cut the NFR values and keep
	valmats <- lapply(mats, subset.data.frame, select=c(reg1:reg2))

	#Cut the BED info and keep
	namemats <- lapply(mats, subset.data.frame, select=c(0:6))

	return(list(namemats, valmats)) #store names and values
}

