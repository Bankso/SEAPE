library(ggplot2)
library(tidyr)
library(dplyr)
make_DIO_plot <- function(counts, type) {
#Displays a bar chart of number of entries in set and a histogram of the number of dyads captured by
#each footprint produced from an extend-and-merge cycle

counts <- counts
type <- type
cdf <- read.delim(file = counts, sep = '\t', header = FALSE)
cdf$V1 <- as.factor(cdf$V1)
cdft <- na.omit(cdf)
colnames(cdft) <- c('Max_dis', 'Dyads_in_print')
pcdft <- cdft %>% filter(!(Max_dis == 0))
if (type == "bar") {
	out <- ggplot(pcdft, aes(x=Max_dis, after_stat(count))) +
		stat_count(position="dodge2")+
		#xlim(0.5, 6.1)+
		theme_bw()+
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
		xlab('Merged region size')+
		ylab('Number of regions')
}

if (type == "hist") {
	out <- ggplot(cdft, aes(x=Dyads_in_print, y=after_stat(count), fill=Max_dis))+
		#scale_colour_gradientn(colours)+
		stat_count(position="dodge2")+
		#xlim(0.5, 6.1)+
		theme_bw()+
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}
show(out)
}
