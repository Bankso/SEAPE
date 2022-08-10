#Scales a list of three matrices by individual input values
#Outputs scaled matrices for plotting and further analysis

sf_scale <- function(sf_prepped, max_list, min_list) {

	binding_data <- sf_prepped #this should be sf_info[[2]] in most cases unless using externally trimmed data
	maxlist <- max_list #List of maximum values to be used in min-max scaling
	minlist <- min_list

	bdmats <- mscaler(binding_data, maxlist, minlist) #scale each matrix by input max/min values
	return(bdmats)
}

