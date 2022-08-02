mscaler <- function(l, ma, mi) {

	x = l[[1]]
	y = l[[2]]
	z = l[[3]]
	m1 = ma[[1]]
	m2 = ma[[2]]
	m3 = ma[[3]]
	i1 = mi[[1]]
	i2 = mi[[2]]
	i3 = mi[[3]]
	sm1 <- (x - i1)/(m1 - i1)
	sm2 <- (y - i2)/(m2 - i2)
	sm3 <- (z - i3)/(m3 - i3)
	mlist <- list(sm1, sm2, sm3)
	return(mlist)
}
