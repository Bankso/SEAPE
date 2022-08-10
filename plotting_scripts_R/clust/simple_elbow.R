simple_elbow <- function(mat, cmax) {
	wss <- (nrow(mat)-1)*sum(apply(mat,2,var))
	for (i in 2:cmax) wss[i] <- sum(kmeans(mat, centers=i)$withinss)
	plot_out <- plot(1:cmax, wss, type="b", xlab="Number of clusters", ylab="Within groups sum of squares")
	return(plot_out)
	}
