library(ClusterR)
library(tidyr)
library(dplyr)

ncl <- as.numeric(clist[[1]]) #Cluster value for long frags
ncs <- as.numeric(clist[[2]]) #Cluster value for short frags

#Long fragment clustering based on user-defined number of k-means clusters

lkm_rc = KMeans_rcpp(lrmat, clusters = ncl, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
lpr = predict(lkm_rc, newdata = lrmat)

lfcmat <- cbind(lpr, elbowdf[, 0:6]) #cluster annotations and BED info

lmat <- cbind(lpr, lrmat) #cluster annotations and points
colnames(lmat) <- c('lpr', as.numeric(1:1000))
lmat$lpr <- as.factor(lmat$lpr)

#Short fragment average NFR signal clustering based on user-defined number of k-means clusters

skm_rc = KMeans_rcpp(srmat, clusters = ncs, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
spr = predict(skm_rc, newdata = srmat)

sfcmat <- cbind(spr, scaled_binding[, 0:5])

smat <- cbind(spr, scaled_binding[, -(0:5)])
colnames(smat) <- c('spr', 't1', 't2', 't3')
smat$spr <- as.factor(smat$spr)
