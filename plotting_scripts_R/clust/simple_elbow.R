simple_elbow <- function(mat) {
	wss <- (nrow(mat)-1)*sum(apply(mat,2,var))
	for (i in 2:20) wss[i] <- sum(kmeans(mat, centers=i)$withinss)
	plot_out <- plot(1:20, wss, type="b", xlab="Number of clusters", ylab="Within groups sum of squares")
	show(plot_out)
	}
