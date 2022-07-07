library(ggplot2)
library(forcats)
library(tidyr)
library(apcluster)
library(NbClust)
library(factoextra)
library(dbscan)
library(ClusterR)

#ggplot(ts_trim, aes(x=V2, after_stat(prop))) +
#	stat_count(aes(color=V1), position="dodge2")+
#	xlim(0.5, 13)

#aes(color=cols)
#x=forcats::fct_infreq(factor(value, order=TRUE))
#histout <- apply(tf_t, 2, hist)
#show(histout)

#tf_t$value <- factor(tf_tidy$value, levels = tf_tidy$cols[order(tf_tidy$cols)])
#ts_t$value <- factor(ts_tidy$value, levels = ts_tidy$cols[order(ts_tidy$cols)])

#ggplot(tf_tidy, aes(x=value, y=cols)) + 
#	stat_bin_2d(aes(color=cols), binwidth=c(1,1), show.legend=FALSE) +
#	scale_y_discrete(limits=factor(merge_set))

#after_stat(ncount)) 

in_order_sort <- sort(in_order)
names(all_df) <- c("merge_value", "JASPAR_0", "JASPAR_20", "JASPAR_50", "JASPAR_100", "JASPAR_200", "JASPAR_500", "JASPAR_1000", "total_dyads")
sorted_df <- all_df[order(all_df$merge_value), ]
sorted_df[-ncol(sorted_df)] <- sorted_df[-ncol(sorted_df)]/sorted_df$total_dyads
sorted_df$merge_value <- sorted_df$merge_value*sorted_df$total_dyads
#heatmap(as.matrix(sorted_df[, 2:8]), Rowv = NA, Colv = NA, keep.dendro = FALSE)
#heatmap.2(as.matrix(sorted_df[, 6]), trace = "n", Colv = NA, Rowv = NA, labCol = names(sorted_df[, 6]), labRow = in_order_sort, cexRow = 1)
#heatmap.2(cbind(sorted_df$JASPAR_50[1:23], sorted_df$JASPAR_50[1:23]), margins = c(4, 9), srtCol = 0, trace="n", Colv = NA, Rowv = NA, labCol = "JASPAR_50", labRow = in_order_sort, cexRow = 1, cexCol = 1, adjCol = c(-1.25,0.5), main = "Abf1 merged SF dyads near consensus sites", key = TRUE)
#heatmap(as.matrix(sorted_df[, 3:4]), Rowv = NA, Colv = NA, keep.dendro = FALSE)

p_r <- 1:18
par(mar = c(5, 5, 4, 4) + 0.25)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_0[p_r],type="l",col="red", xlab = 'Merge distance', ylab = 'Relative % of merged dyads within \n range of consensus sequence', lwd = 2, main = "Abf1 merged small fragment dyads", yaxt = "n")
legend("topright", legend = c("JASPAR 0", "JASPAR 20", "JASPAR 50", "JASPAR 100", "JASPAR 200", "JASPAR 500", "JASPAR 1000"), fill = c("red", "black", "blue", "green", "yellow", "purple", "orange"))
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_20[p_r],type="l",col="black", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_50[p_r],type="l",col="blue", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_100[p_r],type="l",col="green", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_200[p_r],type="l",col="yellow", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_500[p_r],type="l",col="purple", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_1000[p_r],type="l",col="orange", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new=TRUE)
plot(c_vals$merge_dis[p_r],c_vals$count[p_r], type = "l"  , lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Avg dyads per merged site", side = 4, line = 3, col = 4)
#par(new=TRUE)
#plot(x,nucs_val,type="l", lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
#axis(4)
#abline(v=c(50, -50), xpd=2, col="red", lty=2, lwd=2)

gmm = GMM(norm_mat, 2, dist_mode = "maha_dist", seed_mode = "random_subset", km_iter = 10,
					em_iter = 10, verbose = F)          

# predict centroids, covariance matrix and weights
pr = predict(gmm, newdata = norm_mat)

opt_gmm <- Optimal_Clusters_GMM(norm_mat, max_clusters = 50, criterion = "BIC", dist_mode = "maha_dist", seed_mode = "random_subset", km_iter = 10, em_iter = 10, var_floor = 1e-10, plot_data = T)

#op_out <- optics(norm_mat, minPts = 2, eps = 5)
#plot(op_out)
#ex_out <- extractDBSCAN(op_out, eps_cl = 4)
#show(ex_out)

#NbClust(data = NULL, diss = NULL, distance = "euclidean",
#				min.nc = 2, max.nc = 15, method = NULL)

fviz_nbclust(norm_mat, kmeans, method = "silhouette")+
	labs(subtitle = "Silhouette method")

set.seed(123)
fviz_nbclust(norm_mat, kmeans, nstart = 25,  method = "gap_stat", nboot = 50)+
	labs(subtitle = "Gap statistic method")\

ops <- optics(norm_mat, minPts = 10)
plot(ops)
order <- extractDBSCAN(ops, eps_cl = 35)
plot(order)

#d.apclus <- apcluster(negDistMat(r=2), norm_mat)
#cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
# 4
#heatmap(d.apclus)
#plot(d.apclus, d)
