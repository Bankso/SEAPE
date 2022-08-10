sf_cong <- function(bds) {

	bdlist <- bds

	abdmat <- do.call(cbind, bdlist) #combine all scaled matrices into a single df
	abdmat[abdmat < 0] <- 0 #Compress data values that end up outside range of 0-1 after scaling
	abdmat[abdmat > 1] <- 1
	return(abdmat)
}


