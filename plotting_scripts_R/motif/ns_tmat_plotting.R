#Output is average signal for three matrices overlayed on the same plot
#Recommend order of signal plotting be adjusted to make scales work

ns_overlay_plot <- function(matlist, center, ymin, ymax) {
	matlist <- matlist
	rsize <- center
	ymax <- ymax
	ymin <- ymin
	t1c = "black"
	t2c = "blue"
	t3c = "red"

	df_list <- lapply(matlist, read.delim, sep = '\t', header = FALSE)
	tdf_list <- lapply(df_list, na.omit)

	t1 <- data.frame(tdf_list[[1]][-1, -(0:5)])
	t2 <- data.frame(tdf_list[[2]][-1, -(0:5)])
	t3 <- data.frame(tdf_list[[3]][-1, -(0:5)])

	x <- c(-(rsize - 1):rsize) # Range of basepairs used for plotting, default is 1000bp regions
	t1_v <- colMeans(t1)
	t2_v <- colMeans(t2)
	t3_v <- colMeans(t3)
	pl_df <- (data.frame(x, t1_v, t2_v, t3_v))




	plot(pl_df$x, pl_df$t1_v, type="l", col=t1c, ylim=c(ymin, ymax))
	lines(pl_df$x, pl_df$t2_v, col=t2c)
	lines(pl_df$x, pl_df$t3_v, col=t3c)

}
