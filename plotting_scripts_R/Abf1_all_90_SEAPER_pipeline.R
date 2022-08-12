library(caret)
library(dplyr)

#Pipeline for processing and visualizing data derived from mapping coverage onto BED regions using deeptools2
#Expected inputs are deeptools2 formatted matrices:
#chr b1 b2 name score strand data
#Assumed range of data is 7:1006; can be adjusted in scripts
#Tagged factor: Abf1
#Sites: all calculated 90bp targets

sfmats <- c("../data/mats/Abf1_10s_sf_90_marked.matrix",
						"../data/mats/Abf1_20s_sf_90_marked.matrix",
						"../data/mats/Abf1_60s_sf_90_marked.matrix")

lfd <- "../data/mats/Abf1_60s_lf_90_marked.matrix"

bed_file <- "../data/mats/Abf1_sf_90_fps_all_sites_sorted_n.bed"

#Input values
use_bed <- TRUE #Apply the info from a matched bed file, replacing the BED info from input matrices
strand <- FALSE #Is strand information present in the bed file? Not used if use_bed == FALSE
trg <- 90 #predicted size of target regions from DIO calcs
center <- 506 #center column of input data, used to build target regions and subset data
nrml <- FALSE #use a standard min-max scaling function
mscale <- TRUE #use an adjustable percentile-based scaling function - compresses data
tpp <- 0.95 #value to be used as the top percentile in scaling
lpp <- 0.05 #value to be used as the low percentile in scaling
additive <- FALSE #[WIP] Should sfscaled signal be converted to additive signal?

#Convert small fragment signal from three timepoints into scaled binding signal
#Outputs an elbow plot of within group sum of squares calculations to inform unsupervised clustering

cvals <- sf_cbounds(trg, center) #calculate the region bounds for scaled binding
reg1 <- cvals[[1]]
reg2 <- cvals[[2]]

trimlist <- mtrim(sfmats, reg1, reg2) #extract target site signal

if (use_bed == TRUE) { #swap out BED info from input matrices with info from a matching BED file, used to add info not present in matrix
	bdf <- read.delim(bed_file, sep = "\t", header = FALSE)
	trimlist[[1]] <- list(bdf, bdf, bdf)
}

sfpre <- sf_prepro(trimlist) #convert to per basepair signal for each target region at each timepoint
sfdata <- data.frame(sfpre[[2]])
colnames(sfdata) <- c("t1", "t2", "t3")

if (nrml) {
	sfpred <- preProcess(sfdata, method = "range") # standard min-max scaling
	sfscaled <- predict(sfpred, sfdata)
}

if (mscale) { #use my implementation of min-max scaling using quantile values
	qtmax <- apply(sfdata, 2, function(x) quantile(x, probs = tpp))
	qtmin <- apply(sfdata, 2, function(x) quantile(x, probs = lpp))
	maxlist <- list(qtmax[1], qtmax[2], qtmax[3]) #95th percentile values recommended
	minlist <- list(qtmin[1], qtmin[2], qtmin[3]) #5th percentile values recommended
	sfmsc <- mscaler(l = sfdata, maxlist, minlist) #min-max scaling based on percentile values
	sfscaled <- data.frame(sf_cong(sfmsc)) #builds data frame of scaled values and sets x > 1 = 1; x < 0 = 0
}

#Add the names back and remove redundant entries
scbinddf <- unique(cbind(sfpre[[1]], sfscaled))

if (use_bed == TRUE && strand == FALSE) {
	colnames(scbinddf) <-  c("chr", "d1", "d2", "name", "motif", "t1", "t2", "t3")
} else {
	colnames(scbinddf) <-  c("chr", "d1", "d2", "name", "motif", "strand", "t1", "t2", "t3")}

#elbow plotting k-means WSS to find optimal cluster counts
ep <- simple_elbow(sfscaled, 20)
show(ep)

#sftrain <- slice_sample(sfscaled, prop = 0.5) #build a training data set for ML

#Pre-process and elbow plot a single timepoint of long fragment signal

lfpre <- lf_prepro(lfd, bed_file)

lfinfo <- lfpre[[1]]
lfdata <- lfpre[[2]]

#lfpred <- preProcess(lfdata, method = "range") #Min-max scaling of LF data - not necessary for K-means, really distorts the signal patterns
#lfscaled <- predict(lfpred, lfdata)

#lftrain <- slice_sample(lfdata, prop = 0.5) #pull a training set for ML algorithms

simple_elbow(lfdata, 20)

#Experimental feature: adding up signal from across all timepoints
if (additive) {
	at1 <- scbinddf[, 't1']
	at2 <- rowSums(scbinddf[, c('t1', 't2')])
	at3 <- rowSums(scbinddf[, c('t1', 't2', 't3')])
	asrmat <- data.frame(at1, at2, at3)
	asfep <- simple_elbow(asrmat, 30)
	nasrmat <- cbind(scbind[, 0:6], asrmat)
}
