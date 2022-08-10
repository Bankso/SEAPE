mm_overlay_plot <- function(matlist, center, ymin, ymax) {
	matlist <- matlist
	rsize <- center
	ymax <- ymax
	ymin <- ymin
	bed_file <- bedfile
	t1c = "black"
	t2c = "blue"
	t3c = "red"

	df_list <- lapply(matlist, read.delim, sep = '\t', header = FALSE)
	bed <- read.delim(bed_file, sep = '\t', header = FALSE)
	t1 <- na.omit(cbind(bed[, 5], df_list[[1]][-1, -(0:6)]))
	t2 <- na.omit(cbind(bed[, 5], df_list[[2]][-1, -(0:6)]))
	t3 <- na.omit(cbind(bed[, 5], df_list[[3]][-1, -(0:6)]))

	x <- c(-499:500) # Range of basepairs used for plotting

	colnames(t1) <- c("motif", x)
	colnames(t2) <- c("motif", x)
	colnames(t3) <- c("motif", x)

	t1mat <- t1 %>% group_by(motif) %>% summarise_all(mean,na.rm=T)
	t1pmat <- pivot_longer(t1mat, cols = !motif, names_to = 'bp1', values_to = 'avgsig1')

	t2mat <- t2 %>% group_by(motif) %>% summarise_all(mean,na.rm=T)
	t2pmat <- pivot_longer(t2mat, cols = !motif, names_to = 'bp2', values_to = 'avgsig2')

	t3mat <- t3 %>% group_by(motif) %>% summarise_all(mean,na.rm=T)
	t3pmat <- pivot_longer(t3mat, cols = !motif, names_to = 'bp3', values_to = 'avgsig3')

	pl_df <- (cbind(t1pmat, t2pmat, t3pmat)[, c(1,2,3,6,9)])
	pl_df_mm <- pl_df %>% filter(motif == 1)
	pl_df_nm <- pl_df %>% filter(motif == 0)

	ggplot(pl_df_mm, aes(x = bp1, group = motif))+
		geom_line(aes(y = avgsig1), color = t1c)+
		geom_line(aes(y = avgsig2), color = t2c)+
		geom_line(aes(y = avgsig3), color = t3c)+
		ylim(1, 60)

	ggplot(pl_df_nm, aes(x = bp1, group = motif))+
		geom_line(aes(y = avgsig1), color = t1c)+
		geom_line(aes(y = avgsig2), color = t2c)+
		geom_line(aes(y = avgsig3), color = t3c)+
		ylim(1, 60)

	par(mar = c(5, 4, 4, 4) + 0.25)
	plot(pl_df_mm$bp1, pl_df_mm$avgsig1, type="l", col=t1c, ylim=c(1, 7))
	lines(pl_df_mm$bp1, pl_df_mm$avgsig2, col=t2c)
	lines(pl_df_mm$bp1, pl_df_mm$avgsig3, col=t3c)

	par(mar = c(5, 4, 4, 4) + 0.25)
	plot(pl_df_nm$bp1, pl_df_nm$avgsig1, type="l", col=t1c, ylim=c(1, 7))
	lines(pl_df_nm$bp1, pl_df_nm$avgsig2, col=t2c)
	lines(pl_df_nm$bp1, pl_df_nm$avgsig3, col=t3c)

}
