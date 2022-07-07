library(ggplot2)
library(ClusterR)
library(tidyr)
library(dplyr)
library(Hmisc)

#Clusters each set of signals and outputs plots showing the clustered data
#Also produces a plot of the clusters as ordered pairs for each site

plots <- as.logical(show_plots) #Show plots of signal clusters?
ncl <- as.numeric(clist[[1]]) #Cluster value for long frags
ncs <- as.numeric(clist[[2]]) #Cluster value for short frags

#Long fragment clustering based on user-defined number of k-means clusters

km_rcl = KMeans_rcpp(lrmat, clusters = ncl, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
lpr = predict(km_rcl, newdata = lrmat)

lfcmat <- cbind(lpr, elbow_mat[, 0:6])
lmat <- cbind(lpr, elbow_mat[, 7:1006])
colnames(lmat) <- c('lfclust', -499:500) 
lfcmat$lpr <- as.factor(lfcmat$lpr) #lfcmat is primary output, contains site info and clusters

#Short fragment average NFR signal clustering based on user-defined number of k-means clusters

skm_rc = KMeans_rcpp(srmat, clusters = ncs, num_init = 5, max_iters = 100, initializer = 'optimal_init', verbose = F)
spr = predict(skm_rc, newdata = srmat)

sfcmat <- unique(cbind(spr, scaled_binding))
sfcmat$spr <- as.factor(sfcmat$spr) 

if (plots == TRUE) {
	#Plotting LF clustered signal
	lmat$lfclust <- as.factor(lmat$lfclust)
	amat <- lmat %>% group_by(lfclust) %>% summarise_all(mean,na.rm=T)
	plmat <- pivot_longer(amat, cols = !lfclust, names_to = 'bp', values_to = 'count')
	
	ggplot(lfcmat, aes(lpr))+ #Number of sites in each cluster
		geom_bar()
	
	ggplot(plmat, aes(group = lfclust, x = bp, y= count, colour = lfclust, alpha = 0.5))+
		geom_line(position = position_dodge2(width = 1000))
	
	#Plotting SF timepoint signal - plot 2 out of 3 or subtract to reduce dimensions
	ggplot(sfcmat, aes(t1, t2, colour = spr), alpha = 0.25)+
		geom_count(alpha = 0.5)+
		theme_bw()
}

#Combining cluster data and timepoint intensities for each consensus sequence
#Plotting to show distribution of clusters across the cluster-pair space
allmat <- unique(cbind(lfcmat[, c(1,5)], sfcmat)) #allmat is primary output, contains site info and clusters
ggplot(allmat, aes(as.numeric(spr), as.numeric(lpr), alpha = 0.25, colour = after_stat(prop)))+
	scale_colour_gradientn(colours = rainbow(4, alpha = 1))+
	geom_count()+
	theme_bw()

tsnmat <- cbind.data.frame(as.numeric(allmat$spr), as.numeric(allmat$lpr))
tsnplot <- tsne(tsnmat)
tsndf <- as.data.frame(tsnplot)
ggplot(data.frame(tsndf), aes(V1, V2, colour = V1+V2))+
	scale_colour_gradientn(colours = rainbow(4, alpha = 1))+
	geom_count()+
	theme_bw()
