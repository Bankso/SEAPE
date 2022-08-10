library(dplyr)
library(ggplot2)

cl_overlay_plot <- function(matlist, cluster, time, split, clv) {
	if (cluster == 'lf') {cv <- 8}
	if (cluster == 'sf') {cv <- 1}
	time <- as.character(time)
	matlist <- matlist
	split = as.logical(split)
	spv <- clv
	df_list <- lapply(matlist, read.delim, sep = '\t', header = FALSE)
	tdf_list <- lapply(df_list, function(x) {x <- x[-1, ]})
	tdf_list[is.na(tdf_list)] <- 0

	t1 <- data.frame(tdf_list[[1]][, -(0:6)])
	t2 <- data.frame(tdf_list[[2]][, -(0:6)])
	t3 <- data.frame(tdf_list[[3]][, -(0:6)])

	x <- c(1:1000)

	t1c <- cbind(infomat[cv], t1)
	t2c <- cbind(infomat[cv], t2)
	t3c <- cbind(infomat[cv], t3)

	colnames(t1c) <- c("clust", x)
	colnames(t2c) <- c("clust", x)
	colnames(t3c) <- c("clust", x)

	t1cmat <- t1c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
	t1cpmat <- pivot_longer(t1cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')

	t2cmat <- t2c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
	t2cpmat <- pivot_longer(t2cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')

	t3cmat <- t3c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
	t3cpmat <- pivot_longer(t3cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')

	if (time == '1') {tpsmat <- t1cpmat}
	if (time == '2') {tpsmat <- t2cpmat}
	if (time == '3') {tpsmat <- t3cpmat}

	ggplot(tpsmat, aes(bp, avgsig))+
		geom_line(aes(colour = as.factor(clust), group=as.factor(clust), alpha=0.5))+
		xlab("Distance from center (bp)")+
		ylab("Signal")
	#ggsave('lprsplitlf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

	if (split == TRUE) {
		stpsmat <- tpsmat %>% filter(clust == spv)
		ggplot(stpsmat, aes(bp, avgsig))+
			geom_line(aes(colour = as.factor(clust), group=as.factor(clust), alpha=0.5))+
			xlab("Distance from center (bp)")+
			ylab("Signal")}
}
