library(ggplot2)
library(tidyr)
library(forcats)

in_ff <- in_ff
in_sf <- in_sf
tf <- read.delim(file = in_ff, sep = '\t', header = FALSE, fill = TRUE)
ts <- read.delim(file = in_sf, sep = '\t', header = FALSE, fill = TRUE)
tf$V1 <- as.factor(tf$V1)
ts$V1 <- as.factor(ts$V1)

ggplot(tf, aes(x=V2, after_stat(prop))) +
	stat_count(aes(color=V1), position="dodge2")

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
