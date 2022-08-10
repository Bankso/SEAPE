#Pipeline for processing and visualizing data derived from mapping coverage
#onto BED regions using deeptools
#Expected inputs are deeptools2 formatted matrices:
#chr b1 b2 name score strand data
#Assumed range of data is 1:1000; can be adjusted in scripts
#Tagged factor: Abf1
#Sites: all calculated 90bp targets
library(ClusterR)
library(NbClust)
library(caret)

sfmats <- c("../data/mats/Abf1_10s_sf_90_marked.matrix",
						"../data/mats/Abf1_20s_sf_90_marked.matrix",
						"../data/mats/Abf1_60s_sf_90_marked.matrix")

lfd <- "../data/mats/Abf1_60s_lf_90_marked.matrix"

bed_file <- "../data/mats/Abf1_sf_90_fps_all_sites_sorted_n.bed"

#Input values
use_bed <- TRUE #take BED info from an input bed, only necessary if matrix doesn't have the info you want
strand <- FALSE #does BED file contain strand information?
trg <- 90 #predicted size of target regions from DIO calcs
center <- 507
nrml <- FALSE
mscale <- TRUE
ncs <- 3
ncl <- 3
additive <- FALSE

cvals <- sf_cbounds(trg, center) #calculate the region bounds for scaled binding
reg1 <- cvals[[1]]
reg2 <- cvals[[2]]

trimlist <- mtrim(sfmats, reg1, reg2) #extract target site signal

if (use_bed == TRUE) {
	bdf <- read.delim(bed_file, sep = "\t", header = FALSE)
	trimlist[[1]] <- list(bdf, bdf, bdf)
}

sfpre <- sf_prepro(trimlist) #convert to average signal across rows for each target region at each timepoint

if (nrml) {
	sfdata <- data.frame(sfpre[[2]])
	sfpred <- preProcess(sfdata, method = "range") # standard method for min-max scaling
	sfscaled <- predict(sfpred, sfdata)
}

if (mscale) {
	maxlist <- c(70.273, 70.250, 51.665)
	minlist <- c(4.871, 5.167, 4.825)
	sfmsc <- mscaler(l = sfpre[[2]], maxlist, minlist)
	sfscaled <- sf_cong(sfmsc)
}

ep <- simple_elbow(sfscaled, 20) #elbow plotting k-means WSS to find optimal cluster counts
show(ep)

scbinddf <- unique(cbind(sfpre[[1]], sfscaled)) #Add the names back and remove dupes; order should be the same as before splitting

if (use_bed == TRUE && strand == FALSE) {
	colnames(scbinddf) <-  c("chr", "d1", "d2", "name", "motif", "t1", "t2", "t3")
} else {
	colnames(scbinddf) <-  c("chr", "d1", "d2", "name", "motif", "strand", "t1", "t2", "t3")}

#Short fragment average NFR signal clustering based on user-defined number of k-means clusters

skm_rc = KMeans_rcpp(sfscaled, clusters = ncs, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
spr = predict(skm_rc, newdata = sfscaled)

cl_sf_df <- cbind(as.factor(spr), scbinddf) #cluster annotations added to matrix

#LF elbow plotting and clustering

lfpre <- lf_prepro(lfd, bed_file)

lfinfo <- lfpre[[1]]
lfdata <- lfpre[[2]]

#lfpred <- preProcess(lfdata, method = "range")
#lfscaled <- predict(lfpred, lfdata)

simple_elbow(lfdata, 20)

lkm_rc = KMeans_rcpp(lfdata, clusters = ncl, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
lpr = predict(lkm_rc, newdata = lfdata)

cl_lf_df <- cbind(as.factor(lpr), lfinfo, lfdata) #cluster annotations added to matrix

#Experimental feature: adding up signal from across all timepoints
if (additive) {
	at1 <- scbinddf[, 't1']
	at2 <- rowSums(scbinddf[, c('t1', 't2')])
	at3 <- rowSums(scbinddf[, c('t1', 't2', 't3')])
	asrmat <- data.frame(at1, at2, at3)
	asfep <- simple_elbow(asrmat, 30)
	nasrmat <- cbind(scbind[, 0:6], asrmat)
}
