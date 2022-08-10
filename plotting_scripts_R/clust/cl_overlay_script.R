library(dplyr)
library(ggplot2)

#Script for plotting timepoints by cluster annotations

matlist <- c("../data/mats/Abf1_10s_sf_90_fps_marked_TSS_strand.matrix",
						 "../data/mats/Abf1_20s_sf_90_fps_marked_TSS_strand.matrix",
						 "../data/mats/Abf1_60s_sf_90_fps_marked_TSS_strand.matrix")

cluster <- 'lf' #cluster annotations to use for plotting
time <- '3' #timepoint to plot

if (cluster == 'lf') {cv <- 8} #take LF cluster values from infomat
if (cluster == 'sf') {cv <- 1} #take SF cluster values from infomat

split <- TRUE
spv <- 7 #which cluster to plot individually, only used if split == TRUE

#preprocess the data
df_list <- lapply(matlist, read.delim, sep = '\t', header = FALSE)
tdf_list <- lapply(df_list, function(x) {x <- x[-1, ]})
tdf_list[is.na(tdf_list)] <- 0

#convert data to individual dfs
t1 <- data.frame(tdf_list[[1]][, -(0:6)])
t2 <- data.frame(tdf_list[[2]][, -(0:6)])
t3 <- data.frame(tdf_list[[3]][, -(0:6)])

#numbers for column names
x <- c(1:1000)

t1c <- cbind(infomat[cv], t1)
t2c <- cbind(infomat[cv], t2)
t3c <- cbind(infomat[cv], t3)

colnames(t1c) <- c("clust", x)
colnames(t2c) <- c("clust", x)
colnames(t3c) <- c("clust", x)

t1cmat <- t1c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
t1cpmat <- pivot_longer(t1cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')
t1cpmat$order <- c(1:length(t1cpmat$bp))

t2cmat <- t2c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
t2cpmat <- pivot_longer(t2cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')
t2cpmat$order <- c(1:length(t2cpmat$bp))

t3cmat <- t3c %>% group_by(clust) %>% summarise_all(mean,na.rm=T)
t3cpmat <- pivot_longer(t3cmat, cols = !clust, names_to = 'bp', values_to = 'avgsig')
t3cpmat$order <- c(1:length(t3cpmat$bp))

if (time == '1') {tpsmat <- t1cpmat}
if (time == '2') {tpsmat <- t2cpmat}
if (time == '3') {tpsmat <- t3cpmat}

ggplot(tpsmat, aes(reorder(bp, order), avgsig))+
	geom_line(aes(colour = as.factor(clust), group=as.factor(clust)))+
	xlab("Distance from center (bp)")+
	ylab("Signal")+
	theme_bw()+
	scale_x_discrete(labels = c(-500, 0, 500), breaks = c(1, 500, 1000))

#ggsave('lprsplitlf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

if (split == TRUE) {
	stpsmat <- tpsmat %>% filter(clust == spv)
	ggplot(stpsmat, aes(reorder(bp, order), avgsig))+
		geom_line(aes(group=as.factor(clust)))+
		xlab("Distance from center (bp)")+
		ylab("Signal")+
		theme_bw()+
		scale_x_discrete(labels = c(-500, 0, 500), breaks = c(1, 500, 1000))
	}
