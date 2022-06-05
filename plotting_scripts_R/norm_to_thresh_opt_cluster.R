library(apcluster)
library(NbClust)
library(factoextra)
library(dbscan)
library(ClusterR)

input_list <- mat_list
mat_list <- lapply(input_list, read.delim, header=FALSE)
fixed_mat_list <- lapply(mat_list, na.omit)
trimmed_mat_list <- lapply(fixed_mat_list, subset.data.frame, select=c(V1:V4, V7:V506))
all_mat <- do.call(rbind, trimmed_mat_list)
#length(which(all_mat$rows > 30))

min_set <- 1
max_set <- 30
norm_mat <- ((all_mat[, -(1:4)] - min_set)/(max_set - min_set))
norm_mat[norm_mat < 0] <- 0
norm_mat[norm_mat > 1] <- 1

#gmm = GMM(norm_mat, 2, dist_mode = "maha_dist", seed_mode = "random_subset", km_iter = 10,
#					em_iter = 10, verbose = F)          

# predict centroids, covariance matrix and weights
#pr = predict(gmm, newdata = norm_mat)

opt_gmm <- Optimal_Clusters_GMM(norm_mat, max_clusters = 50, criterion = "BIC", dist_mode = "maha_dist", seed_mode = "random_subset", km_iter = 10, em_iter = 10, var_floor = 1e-10, plot_data = T)

#op_out <- optics(norm_mat, minPts = 2, eps = 5)
#plot(op_out)
#ex_out <- extractDBSCAN(op_out, eps_cl = 4)
#show(ex_out)

#NbClust(data = NULL, diss = NULL, distance = "euclidean",
#				min.nc = 2, max.nc = 15, method = NULL)

#fviz_nbclust(norm_mat, kmeans, method = "silhouette")+
#	labs(subtitle = "Silhouette method")

#set.seed(123)
#fviz_nbclust(norm_mat, kmeans, nstart = 25,  method = "gap_stat", nboot = 50)+
#	labs(subtitle = "Gap statistic method")

#ELbow plotting
#wss <- (nrow(norm_mat)-1)*sum(apply(norm_mat,2,var))
#for (i in 2:20) wss[i] <- sum(kmeans(norm_mat, centers=i)$withinss)
#plot_out <- plot(1:20, wss, type="b", xlab="Number of clusters", ylab="Within groups sum of squares")

#d.apclus <- apcluster(negDistMat(r=2), norm_mat)
#cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
# 4
#heatmap(d.apclus)
#plot(d.apclus, d)
