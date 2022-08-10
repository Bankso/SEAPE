library(Hmisc)

sf_prepro <- function(tmats) {

	names <- tmats[[1]]
	nmat <- unique(do.call(rbind, names))

	vals <- tmats[[2]]
	raw_binding <- lapply(vals, rowMeans)

	matinfo <- lapply(raw_binding, describe)

	sf_info <- list(nmat, raw_binding, matinfo)
	return(sf_info)

}
