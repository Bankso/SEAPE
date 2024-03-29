library(BBmisc)

#Processes LF binding signal
#Final output is an elbow plot. Data frames built in this program are used in make_clusters

mat_input <- lfmat
elbow_mat <- read.delim(mat_input, header=FALSE)
regs <- bed_file
reg_mat <- read.delim(regs, header=FALSE)
lfcdf <- data.frame(reg_mat, elbow_mat[2:nrow(elbow_mat), 6:ncol(elbow_mat)])
elbowdf <- na.omit(lfcdf)
lrmat <- elbowdf[0:nrow(elbowdf), 7:ncol(elbowdf)]
#nlrmat <- normalize(lrmat, method="range", range=c(0,1))
#simple_elbow(lrmat, 30)

