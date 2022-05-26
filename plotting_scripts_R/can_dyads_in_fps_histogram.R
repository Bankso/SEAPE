library(ggplot2)
library(tidyr)
library(forcats)

in_ff <- in_ff
in_sf <- in_sf
merge_set <- list(2,4,6,8,10,12,14,16,18,20,30,40,50,60,70,80,90,100,120,150,200,250,300,400,500,1000)

tf <- read.delim(file = in_ff, sep = '\t', header = FALSE, fill = TRUE)
ts <- read.delim(file = in_sf, sep = '\t', header = FALSE, fill = TRUE)

tf_t <- data.frame(t(tf))
ts_t <- data.frame(t(ts))
colnames(tf_t) <- merge_set
colnames(ts_t) <- merge_set


tf_tidy <- gather(tf_t, cols, value)
ts_tidy <- gather(ts_t, cols, value)

ggplot(tf_tidy, aes(x=value, fill=cols)) +
	stat_count(aes(color=value), position="dodge2")
	#scale_x_discrete(limits=factor(merge_set))

#aes(color=cols)
#y=forcats::fct_infreq(factor(value, order=TRUE)),
#histout <- apply(tf_t, 2, hist)
#show(histout)

#tf_t$value <- factor(tf_tidy$value, levels = tf_tidy$cols[order(tf_tidy$cols)])
#ts_t$value <- factor(ts_tidy$value, levels = ts_tidy$cols[order(ts_tidy$cols)])

#ggplot(tf_tidy, aes(x=value, y=cols)) + 
#	stat_bin_2d(aes(color=cols), binwidth=c(1,1), show.legend=FALSE) +
#	scale_y_discrete(limits=factor(merge_set))

#after_stat(ncount)) 
