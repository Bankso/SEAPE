#Processes LF binding signal and adds in BED info from a paired BED file used to make the matrix with deeptools2
#Final output is an elbow plot. Data frames built in this program are used in make_clusters

lf_prepro <- function(lfmat, bed_file) {

	mat_input <- lfmat
	lfdf <- read.delim(mat_input, header=FALSE)

	if (!is.na(bed_file)) {
		regs <- bed_file
		reg_mat <- read.delim(regs, header=FALSE)
		lfbed <- data.frame(reg_mat)
		}

	if (is.na(bed_file)) {
		lfbed <- lfdf[2:nrow(lfdf), 1:6]
		}

	lrmat <- lfdf[2:nrow(lfdf), 7:ncol(lfdf)]
	lrmat[is.na(lrmat)] <- 0

	return(list(lfbed, lrmat))
}
