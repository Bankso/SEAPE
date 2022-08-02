library(dbscan)
library(ClusterR)
library(ggbiplot)
library(tidyr)
library(plyr)
library(Hmisc)

matlist <- input_list
maxlist <- max_list
p <- FALSE

mermat <- mscaler(raw_binding, maxlist) #scale each matrix by a pre-set max value
#mermat[mermat < 0] <- 0 #Trim the ends of the values to fit within 0/1
#mermat[mermat > 1] <- 1
nmermat <- cbind(nmat, mermat) #Add the names back; order should be the same as before splitting

pca <- prcomp(tmat[, -(0:5)], center = FALSE, scale. = FALSE) #PCA for reducing dimensions pre-clustering
summary(pca)
ggbiplot(pca)
if (p == TRUE) {
	rmat <- data.frame(pca$x[, 0:4]) #principal components; can be used instead of raw values for clustering
} else {
	rmat <- nmermat[, -(0:5)]
	}
#opt = Optimal_Clusters_KMeans(rmat, max_clusters = 20, plot_clusters = T, criterion = 'distortion_fK', fK_threshold = 0.85, initializer = 'kmeans++', tol_optimal_init = 0.2)
colnames(rmat) <- c('t1', 't2', 't3')
#ELbow plotting
wss <- (nrow(rmat)-1)*sum(apply(rmat,2,var))
for (i in 2:20) wss[i] <- sum(kmeans(rmat, centers=i)$withinss)
plot_out <- plot(1:20, wss, type="b", xlab="Number of clusters", ylab="Within groups sum of squares")

km_rc = KMeans_rcpp(rmat, clusters = 6, num_init = 5, max_iters = 100,
										initializer = 'kmeans++', verbose = F)
pr = predict(km_rc, newdata = rmat)

cmat <- cbind(pr, tmat)
cmat$pr <- as.factor(cmat$pr)

bp <- as.numeric(-499:500)
colnames(cmat) <- c('clust', 'chr', 'b1', 'b2', 'name', 'strand', bp)
pmat <- cmat[, -c(2:6)]
plmat <- pivot_longer(pmat, cols = !clust, names_to = "position", values_to = "intensity")

ggplot(plmat, aes(position, intensity, colour = clust), alpha = 0.5)+
	geom_count()
trace <- plot(plmat$position, plmat$intensity)
show(trace)
