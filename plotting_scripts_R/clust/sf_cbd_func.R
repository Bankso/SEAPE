#This processes SF binding signal into a scaled matrix with the bed entries
#Requires a list of three matrices from timepoints of SpLiT-ChEC small frag signal

sf_cbounds <- function(region_size, mat_center) {

regsize <- as.numeric(region_size) #size of regions to be cut and kept for intensity analysis
cval <- as.numeric(mat_center) #the midpoint of the dataset in non-negative values
#if values are 1-1000bp regions, center is 500

rv1 <- as.character(cval - (regsize/2))
rv2 <- as.character(cval + (regsize/2))

return(list(rv1, rv2))
}
