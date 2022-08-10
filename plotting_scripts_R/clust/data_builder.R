library(dplyr)
library(tidyverse)

#Build various data frames for plotting
#Requires pre-processed matrices from the base SEAPER pipeline

lmat <- cl_lf_df #pre-processed and clustered LF data
smat <- cl_sf_df #pre-processed and clustered SF data
strand <- FALSE #strand info is present
prng <- factor(1:1000, levels=1:1000)
zrng <- factor(400:600, levels=400:600) #range to plot zoomed in LF
ztrm <- 400:600

if (strand) {
	rng <- (0:7)
	ub <- 7
	}

if (!strand) {
	rng <- (0:6)
	ub <- 6
}

#LF points with Sf cluster annotations
slfmat <- cbind(as.factor(smat[, 1]), lmat[, -(rng)])
colnames(slfmat) <-  c('SF cluster', prng)

#SF points with LF cluster annotations
lsfmat <- cbind(as.factor(lmat[, 1]), smat[, -(rng)])
colnames(lsfmat) <-  c('LF cluster', '10s', '20s', '60s')

#BED info and cluster annotations, helpful for seeing that file order doesn't change
infomat <- data.frame(cbind(smat[, (rng)], lmat[, (rng)]))
if (strand) {colnames(infomat) <-
	c('SF cluster', 'chrs', 's1', 's2', 'sname', 'smotif', 'sstrand', 'LF cluster', 'chrl', 'l1', 'l2', 'lname', 'lmotif', 'lstrand')
}
if (!strand) {colnames(infomat) <-
	c('SF cluster', 'chrs', 's1', 's2', 'sname', 'smotif', 'LF cluster', 'chrl', 'l1', 'l2', 'lname', 'lmotif')}

#LF signal with MM annotations
lmomat <- cbind(as.factor(infomat[, 'lmotif']), lmat[,-(rng)])
colnames(lmomat) <- c('motif', prng)

#MM summarized LF signal
lpmmat <- lmomat %>% group_by(motif) %>% summarise_all(mean, na.rm=T)
lplmat <- pivot_longer(lpmmat, cols = !motif, names_to = 'bp', values_to = 'count')
lplmat$order <- c(1:length(lplmat$bp))

#SF signal with MM annotations
smomat <- cbind(as.factor(infomat[, 'smotif']), smat[,-(rng)])
colnames(smomat) <- c('motif', '10s', '20s', '60s')

#MM summarized SF signal
mmmat <- smomat %>% filter(motif == 1)
nmmat <- smomat %>% filter(motif == 0)

spmmat <- smomat %>% group_by(motif) %>% summarise_all(mean,na.rm=T)
spsmat <- pivot_longer(spmmat, cols = !motif, names_to = 'time', values_to = 'avgsig')
spsmat$order <- c(1:length(spsmat$time))

#LPR summarized LF signal
slmat <- lmat[, -(2:ub)] %>% group_by(`as.factor(lpr)`) %>% summarise_all(mean,na.rm=T)
colnames(slmat) <- c("LF cluster", prng)
plmat <- pivot_longer(slmat, cols = !`LF cluster`, names_to = 'bp', values_to = 'count')
plmat$order <- c(1:length(plmat$bp))

#LPR summarized LF signal zoom in, adjust values to plot as desired
talmat <- lmat[, c(1, ztrm)] %>% group_by(`as.factor(lpr)`) %>% summarise_all(mean,na.rm=T)
colnames(talmat) <- c("LF cluster", zrng)
tplmat <- pivot_longer(talmat, cols = !`LF cluster`, names_to = 'bp', values_to = 'count')
tplmat$order <- c(1:length(tplmat$bp))

#SPR summarized LF signal
salmat <- slfmat %>% group_by(`SF cluster`) %>% summarise_all(mean,na.rm=T)
splmat <- pivot_longer(salmat, cols = !`SF cluster`, names_to = 'bp', values_to = 'count')
splmat$order <- c(1:length(splmat$bp))

#SPR summarized SF signal
asmat <- smat[, -(2:ub)] %>% group_by(`as.factor(spr)`) %>% summarise_all(mean,na.rm=T)
colnames(asmat) <- c("SF cluster", "10s", "20s", "60s")
psmat <- pivot_longer(asmat, cols = !`SF cluster`, names_to = 'time', values_to = 'avgsig')
psmat$order <- c(1:length(psmat$time))

#LPR summarized SF signal
lasmat <- lsfmat %>% group_by(`LF cluster`) %>% summarise_all(mean,na.rm=T)
lpsmat <- pivot_longer(lasmat, cols = !`LF cluster`, names_to = 'time', values_to = 'avgsig')
lpsmat$order <- c(1:length(lpsmat$time))
