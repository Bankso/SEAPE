library(BBmisc)

#Processes LF binding signal
#Final output is an elbow plot. Data frames built in this program are used in make_clusters

mat_input <- lfmat
elbow_mat <- read.delim(mat_input, header=FALSE)
elbowdf <- na.omit(elbow_mat)
lrmat <- elbowdf[0:nrow(elbowdf), 7:ncol(elbowdf)]
#nlrmat <- normalize(lrmat, method="range", range=c(0,1))
simple_elbow(lrmat, 30)
