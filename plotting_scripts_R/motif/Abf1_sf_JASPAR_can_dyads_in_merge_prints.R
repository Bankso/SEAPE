library(stringr)

sf <- sfcounts
jaspar <- jcounts
inset <- c(sf, jaspar)
jtot <- 2272 # total number of JASPAR dyads used in calculations
sftot <- 1731 # total number of SF dyads used in calculations

sfd <- read.table(file = sf, sep = '', header = FALSE)
jsd <- read.table(file = jaspar, sep = '', header = FALSE)
l <- length(sfd$V1) #Same value for both sets
trim <- l - 1
x <- c(0, 1000, 100, 10, 120, 12, 14, 150, 16, 18, 200, 20, 250, 2, 300, 30, 400, 40, 4, 500, 50, 600, 60, 6, 70, 800, 80, 8, 90)
sdf <- data.frame(x, sfd$V1[-30], type=as.factor("SpLiT-ChEC-seq peaks"))
jdf <- data.frame(x, jsd$V1[-30], type=as.factor("JASPAR MA0265.2"))

sdf$sfd.V1..30. <- sdf$sfd.V1..30./sftot
jdf$jsd.V1..30. <- jdf$jsd.V1..30./jtot

all_df <- data.frame(distance=x, count=c(sdf$sfd.V1..30., jdf$jsd.V1..30.), Site_type=c(sdf$type, jdf$type))
par(mar = c(5, 5, 4, 4) + 0.25)
plot <- ggplot(all_df, aes(distance, count, Site_type, colour=Site_type))+
	ggtitle(" Consensus sequence dyads located in \n merged small fragment \n peaks identified by MACS3 \n from Abf1 SpLiT-ChEC-seq coverage")+
	geom_point(alpha=0.75, size=3, show.legend = TRUE)+
	ylab("% of dyads captured by merged entries")+
	xlab("Maximum distance between merged dyads (bp)")+
	theme_bw()

plot + scale_fill_discrete(name='Consensus sequence source', labels=c('Abf1 SpLiT-ChEC seq small fragment peaks', 'Abf1 JASPAR entry MA0265.2'))
	
	
