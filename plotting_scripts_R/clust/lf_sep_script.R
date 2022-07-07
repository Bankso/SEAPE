#Processes LF binding signal
#Final output is an elbow plot. Data frames built in this program are used by rel_data_clustering.R


mat_input <- lfmat
elbow_mat <- read.delim(mat_input, header=FALSE)
elbow_mat <- na.omit(elbow_mat)
lrmat <- elbow_mat[0:nrow(elbow_mat), 7:ncol(elbow_mat)]

simple_elbow(lrmat)

