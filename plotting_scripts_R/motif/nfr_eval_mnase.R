library(ggplot2)

#This script overlays the signal from two input matrices
#Primary use is to overlay SpLiT-ChEC and MNase-seq signal for NFR analysis

inmat <- in_mat #SpLiT-ChEC data
innucs <- in_nucs #MNase data
range <- bp_rng

m <- na.omit(read.delim(file = inmat, sep = '\t', header = FALSE))
n <- na.omit(read.delim(file = innucs, sep = '\t', header = FALSE))

m_df <- data.frame(m)[-1, -(0:6)]
n_df <- data.frame(n)[-1, -(0:6)]

x <- c(-499:500)
m_v <- colMeans(m_df)
n_v <- colMeans(n_df)
pl_df <- (data.frame(x, m_v, n_v))[range,]
mv_df <- (data.frame(x, m_v))[range,]
nv_df <- (data.frame(x, n_v))[range,]

par(mar = c(5, 4, 4, 4) + 0.25)
plot(pl_df$x,pl_df$m_v,type="l",col="black", xlab = 'bp', ylab = 'SpLiT-ChEC signal', lwd = 2)
par(new=TRUE)
plot(pl_df$x,pl_df$n_v,type="l", lwd=2 , col="red", xlab = '', ylab = '', axes=FALSE, lty = "dotted")
axis(4)
mtext("MNase-seq signal", side = 4, line = 3, col = "red")

#ggplot()+
#	geom_line(data = mv_df, aes(x = x, y = m_v), color = 'black')+
#	geom_line(data = nv_df, aes(x = x, y = n_v), color = 'red')

