mscaler <- function(l, m) {
	min = 1
	x = l[[1]]
	y = l[[2]]
	z = l[[3]]
	m1 = m[[1]]
	m2 = m[[2]]
	m3 = m[[3]]
	sm1 <- (x - min)/(m1 - min)
	sm2 <- (y - min)/(m2 - min)
	sm3 <- (z - min)/(m3 - min)
	mlist <- list(sm1, sm2, sm3)
	return(mlist)
}
