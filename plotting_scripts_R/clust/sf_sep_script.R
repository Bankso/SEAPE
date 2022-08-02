library(tidyr)
library(plyr)
library(dplyr)
library(Hmisc)
#Scales a list of three timepoint matrices by individual input values
#Outputs scaled matrices for plotting and further analysis

maxlist <- max_list #List of maximum values to be used in min-max scaling
minlist <- min_list
mermat <- mscaler(raw_binding, maxlist, minlist) #scale each matrix by a pre-set max value
amermat <- do.call(cbind, mermat)
amermat[amermat < 0] <- 0 #Trim the ends of the values to fit within 0/1
amermat[amermat > 1] <- 1
nmermat <- cbind(nmat, amermat) #Add the names back; order should be the same as before splitting

scaled_binding <- unique(nmermat) #Remove duplicates created from cbind
colnames(scaled_binding) <- c("chr", "d", "d1", "name", "mm", "t1", "t2", "t3")
srmat <- scaled_binding[, -(0:5)]

simple_elbow(srmat, 30)
