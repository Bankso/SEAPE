library(ggplot2)
library(dplyr)
library(tidyverse)
library(tsne)
library(BSDA)

#Plotting the outputs from data_builder script
#Saving is not standard - mark which plots should be saved
#Change save names/formats as required

#Number of sites in each LF cluster
ggplot(lmat, aes(lpr))+
	geom_bar()+
	theme_bw()+
	xlab("LF cluster ID")+
	ylab("Number of sites")

#ggsave('lfcounts.tiff', device = 'tiff', units = 'cm', width = 5, height = 7, dpi = 300)

#Number of sites in each SF cluster
ggplot(smat, aes(spr))+
	geom_bar()+
	theme_bw()+
	xlab("SF cluster ID")+
	ylab("Number of sites")

#ggsave('sfcounts.tiff', device = 'tiff', units = 'cm', width = 5, height = 7, dpi = 300)

#Plot LF clusters counts, bars colored with counts of +/- mm
ggplot(infomat, aes(x = `LF cluster`, fill = factor(lmotif)))+
	geom_bar()+
	theme_bw()+
	xlab("LF cluster ID")+
	ylab("Number of sites")

#ggsave('lfcounts_mm.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plot SF clusters counts, bars colored with counts of +/- mm
ggplot(infomat, aes(x = `SF cluster`, fill = factor(smotif)))+
	geom_bar()+
	theme_bw()+
	xlab("SF cluster ID")+
	ylab("Number of sites")

#ggsave('sfcounts_mm.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plotting SF timepoint signal by SF cluster using 2 timepoints
ggplot(smat, aes(t2, t3, colour = factor(spr)))+
	geom_count(alpha = 0.5)+
	theme_bw()+
	xlab("20s target signal")+
	ylab("60s target signal")

#ggsave('spr_sf_points.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plotting LF signal with MM annotations
ggplot(lplmat, aes(reorder(bp, order), count, colour=motif, group = motif))+
	geom_line()+
	xlab("Distance from center (bp)")+
	ylab("Signal")+
	scale_x_discrete(labels = c(-500, 0, 500), breaks = c(1, 500, 1000))+
	theme_bw()

#ggsave('mmslf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#box plots of SF signal split by MM at each timepoint
ggplot(smomat, aes(x=motif, y=`10s`, group=motif))+
	geom_boxplot()+
	theme_bw()
ggplot(smomat, aes(motif, `20s`, group=motif))+
	geom_boxplot()+
	theme_bw()
ggplot(smomat, aes(motif, `60s`, group=motif))+
	geom_boxplot()+
	theme_bw()

#MM summarized SF signal
ggplot(spsmat, aes(reorder(time, order), avgsig, color=motif, fill=motif, group=motif))+
	geom_point()+
	geom_path()+
	theme_bw()+
	xlab("Digestion time (s)")+
	ylab("Average target signal")

#ggsave('mm_sf_traj.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#MM-based coloring of plotted SF points, 2 of 3 or reduce
ggplot(smomat, aes(`20s`, `60s`, colour = motif), alpha = 0.25)+
	geom_count(alpha = 0.5)+
	theme_bw()+
	xlab("20s target signal")+
	ylab("60s target signal")

#ggsave('mm_sf_points.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LF cluster summarized LF signal
ggplot(plmat, aes(reorder(bp, order), count))+
	geom_line(aes(colour = `LF cluster`, group=`LF cluster`))+
	xlab("Distance from center (bp)")+
	ylab("Signal")+
	theme_bw()+
	scale_x_discrete(labels = c(-500, 0, 500), breaks = c(1, 500, 1000))


#ggsave('lprsplitlf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LF zoom in by LF cluster
ggplot(tplmat, aes(reorder(bp, order), count))+
	geom_line(aes(colour=`LF cluster`, group=`LF cluster`))+
	xlab("Distance from center (bp)")+
	ylab("Signal")+
	theme_bw()+
	scale_x_discrete(labels = c(-100, 0, 100), breaks = c(1, 100, 200))

#ggsave('lprsplitlf_200_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#SF cluster summarized LF signal
ggplot(splmat, aes(group = `SF cluster`, x = reorder(bp, order), y= count, colour = `SF cluster`))+
	geom_line()+
	xlab("Distance from center (bp)")+
	ylab("Signal")+
	scale_x_discrete(labels = c(-500, 0, 500), breaks = c(1, 500, 1000))+
	theme_bw()

#ggsave('sprsplitlf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#SF cluster summarized SF signal
ggplot(psmat, aes(reorder(time, order), avgsig, color=`SF cluster`, fill=`SF cluster`, group=`SF cluster`))+
	geom_point()+
	geom_path()+
	xlab("Digestion time (s)")+
	ylab("Average target signal")+
	theme_bw()

#ggsave('sprsplitsf_tss.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#LF cluster summarized SF signal
ggplot(lpsmat, aes(reorder(time, order), avgsig, color=`LF cluster`, fill=`LF cluster`, group=`LF cluster`))+
	geom_point()+
	geom_path()+
	xlab("Digestion time (s)")+
	ylab("Average target signal")+
	theme_bw()

#ggsave('lprsplitsf.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)

#Plotting cluster annotations as x,y pairs
plot_cart <- FALSE #plot cluster annotations as x,y pairs to see if any groups are over represented in interesting ways

if (plot_cart) {
	ggplot(infomat, aes(as.numeric(`SF cluster`), as.numeric(`LF cluster`)))+
		geom_count(aes(colour=after_stat(prop)))+
		scale_colour_gradientn(colours = rainbow(4, alpha=1))+
		theme_bw()+
		scale_x_continuous(limits=c(1,6), breaks = c(1,2,3,4,5,6))+
		scale_y_continuous(limits=c(1,8), breaks = c(1,2,3,4,5,6,7,8))
	#ggsave('sf_lf_cart_map.tiff', device = 'tiff', units = 'cm', width = 10, height = 10, dpi = 300)
	}


tsne_map <- FALSE #build TSNE map based on cluster annotations?
if (tsne_map) {
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
