#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
mat_input <- args[1]
plot_out <- args[2]
elbow_mat <- read.delim(mat_input, header=FALSE)
elbow_mat <- na.omit(elbow_mat)
elbow_mat_trimmed <- elbow_mat[2:nrow(elbow_mat), 7:ncol(elbow_mat)]
wss <- (nrow(elbow_mat_trimmed)-1)*sum(apply(elbow_mat_trimmed,2,var))
for (i in 2:30) wss[i] <- sum(kmeans(elbow_mat_trimmed, centers=i)$withinss)
plot_out <- plot(1:30, wss, type="b", xlab="Number of clusters", ylab="Within groups sum of squares")
