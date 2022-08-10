library(ggplot2)
library(dplyr)
library(tsne)
library(BSDA)

#Combining cluster data and timepoint intensities for each consensus sequence
#Takes lmat and smat as inputs
#lmat is a data frame with coverage intensities for a set of BED regions and cluster annotations for each region
#smat is the same, except contains average binding intensities across three timepoints for target sites and cluster annotations for each region
#Either can be generated above from inputs or files of this format can be fed directly by first reading in with read.delim()

#Number of sites in each LF cluster
ggplot(lmat, aes(lpr))+
	geom_bar()+
	theme_bw()+
	xlab("LF cluster ID")+
	ylab("Number of sites in cluster")

ggsave('tsslfcounts.tiff', device = 'tiff', units = 'cm', width = 5, height = 7, dpi = 300)

#Number of sites in each SF cluster
ggplot(smat, aes(spr))+
	geom_bar()+
	theme_bw()+
	xlab("SF cluster ID")+
	ylab("Number of sites in cluster")

ggsave('tsssfcounts.tiff', device = 'tiff', units = 'cm', width = 5, height = 7, dpi = 300)

#contains all LF points with Sf cluster annotations
sffmat <- cbind(lmat[, -(0:1)], as.factor(smat$spr))
colnames(sffmat) <-  c(as.numeric(1:1000), 'spr')

#contains all SF points with LF cluster annotations
lsfmat <- cbind(smat[, -(0:1)], as.factor(lmat$lpr))
colnames(lsfmat) <-  c('t1', 't2', 't3', 'lpr')

#contains all BED info and cluster annotations, helpful for seeing that file order doesn't change
infomat <- data.frame(cbind(sfcmat[,0:5], lfcmat[, 0:7]))

#Plot LF clusters counts, bars colored with counts of +/- mm
ggplot(infomat, aes(x = lpr, fill = factor(V5)))+
	geom_bar()+
	theme_bw()+
	xlab("LF cluster ID")+
	ylab("Number of sites in cluster")

ggsave('lfcounts_mm.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plot SF clusters counts, bars colored with counts of +/- mm
ggplot(infomat, aes(x = spr, fill = factor(V5)))+
	geom_bar()+
	theme_bw()+
	xlab("SF cluster ID")+
	ylab("Number of sites in cluster")

ggsave('sfcounts_mm.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plotting SF timepoint signal by SF cluster - using 2 timepoints
ggplot(smat, aes(t2, t3, colour = spr), alpha = 0.25)+
	geom_count(alpha = 0.5)+
	theme_bw()+
	xlab("20s target signal")+
	ylab("60s target signal")

ggsave('spr_sf_points_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LF signal with MM annotations
lmomat <- cbind(as.factor(infomat[, 'V5']), lmat[,-(0:1)])
colnames(lmomat) <- c('motif', as.numeric(1:1000))

#MM summarized LF signal
lpmmat <- lmomat %>% group_by(motif) %>% summarise_all(mean, na.rm=T)
lpsmat <- pivot_longer(lpmmat, cols = !motif, names_to = 'bp', values_to = 'count')

ggplot(lpsmat, aes(bp, count))+
	geom_path(aes(colour = motif, group=motif, alpha=0.5), position = position_dodge2(width=1000))+
	xlab("Distance from center (bp)")+
	ylab("Signal")

ggsave('mmslf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)


#SF signal with MM annotations
smomat <- cbind(as.factor(infomat[, 'V5']), smat[,-(0:1)])
colnames(smomat) <- c('motif', 't1', 't2', 't3')

ggplot(smomat, aes(motif, t1, t2, t3))+
	geom_boxplot()+
	theme_bw()

#MM summarized SF signal
mmmat <- smomat %>% filter(motif == 1)
nmmat <- smomat %>% filter(motif == 0)
spmmat <- pmmat %>% summarise_all(mean,na.rm=T)
spsmat <- pivot_longer(spmmat, cols = !motif, names_to = 'time', values_to = 'avgsig')



ggplot(spsmat, aes(motif, avgsig, color=time, fill=time, group=motif))+
	geom_point(aes(), position=position_dodge2(preserve = 'total', width = 2))+
	geom_path(aes(), position=position_dodge2(preserve = 'total', width = 2))+
	scale_fill_manual(values = c('black', 'blue', 'red'))+
	scale_color_manual(values = c('black', 'blue', 'red'))+
	theme_bw()+
	xlab("Target sequence group")+
	ylab("Average region signal")

ggsave('mm_sf_traj.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#MM-based coloring of plotted SF points, 2 of 3 or reduce
ggplot(smomat, aes(t2, t3, colour = motif), alpha = 0.25)+
	geom_count(alpha = 0.5)+
	theme_bw()+
	xlab("20s average region signal")+
	ylab("60s average region signal")

ggsave('mm_sf_points.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LPR summarized LF signal
almat <- lmat %>% group_by(lpr) %>% summarise_all(mean,na.rm=T)
plmat <- pivot_longer(almat, cols = !lpr, names_to = 'bp', values_to = 'count')

ggplot(plmat, aes(bp, count))+
	geom_line(aes(colour = lpr, group=lpr, alpha=0.5), position = position_dodge2(width=1000))+
	xlab("Distance from center (bp)")+
	ylab("Signal")

ggsave('lprsplitlf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LPR summarized LF signal zoom in
talmat <- lmat[, c(1, 400:600)] %>% group_by(lpr) %>% summarise_all(mean,na.rm=T)
tplmat <- pivot_longer(talmat, cols = !lpr, names_to = 'bp', values_to = 'count')

ggplot(tplmat, aes(bp, count))+
	geom_line(aes(colour = lpr, group=lpr, alpha=0.5), position = position_dodge2(width=200))+
	xlab("Distance from center (bp)")+
	ylab("Signal")

ggsave('lprsplitlf_200_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#SPR summarized LF signal
salmat <- sffmat %>% group_by(spr) %>% summarise_all(mean,na.rm=T)
splmat <- pivot_longer(salmat, cols = !spr, names_to = 'bp', values_to = 'count')

ggplot(splmat, aes(group = spr, x = bp, y= count, colour = spr, alpha = 0.5))+
	geom_line(position = position_dodge2(width = 1000))+
	xlab("Distance from center (bp)")+
	ylab("Signal")

ggsave('sprsplitlf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#SPR summarized SF signal
asmat <- smat %>% group_by(spr) %>% summarise_all(mean,na.rm=T)
psmat <- pivot_longer(asmat, cols = !spr, names_to = 'time', values_to = 'avgsig')

ggplot(psmat, aes(spr, avgsig, color=time, fill=time, group=spr))+
	geom_point(aes(), position=position_dodge2(preserve = 'total', width = ncs, padding = 2))+
	geom_path(aes(), position=position_dodge2(preserve = 'total', width = ncs, padding = 2))+
	scale_fill_manual(values = c('black', 'blue', 'red'))+
	scale_color_manual(values = c('black', 'blue', 'red'))+
	theme_bw()+
	xlab("SF cluster ID")+
	ylab("Average region signal")

ggsave('sprsplitsf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LPR summarized SF signal
lasmat <- lsfmat %>% group_by(lpr) %>% summarise_all(mean,na.rm=T)
lpsmat <- pivot_longer(lasmat, cols = !lpr, names_to = 'time', values_to = 'avgsig')

ggplot(lpsmat, aes(lpr, avgsig, color=time, fill=time, group=lpr))+
	geom_point(aes(), position=position_dodge2(preserve = 'total', width = ncl, padding = 2))+
	geom_path(aes(), position=position_dodge2(preserve = 'total', width = ncl, padding = 2))+
	scale_fill_manual(values = c('black', 'blue', 'red'))+
	scale_color_manual(values = c('black', 'blue', 'red'))+
	theme_bw()+
	xlab("LF cluster ID")+
	ylab("Average region signal")

ggsave('lprsplitsf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plotting cluster annotations as x,y pairs
ggplot(infomat, aes(X1, X2, colour = after_stat(prop)))+
	geom_count()+
	scale_colour_gradientn(colours = rainbow(4, alpha = 1))+
	theme_bw()+
	xlim(1, 3)+
	ylim(1, 3)


make_map <- FALSE #build x,y and TSNE maps based on cluster annotations?
if (make_map == TRUE) {
#TSNE mapping of all input regions based on cluster annotations used as x,y pairs
#Doesn't show anything different than plot above for 2-D data
#This could technically be used to visualize similar points without doing any k-means clustering
tsnmat <- cbind.data.frame(as.numeric(infomat$spr), as.numeric(infomat$lpr))
tsnplot <- tsne(tsnmat, max_iter = 500, initial_dims = 2)
tsndf <- as.data.frame(tsnplot)
ggplot(data.frame(tsndf), aes(V1, V2, colour = V1+V2))+
	scale_colour_gradientn(colours = rainbow(4, alpha = 1))+
	geom_count()+
	theme_bw()
}
