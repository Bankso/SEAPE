library(ggplot2)

#This script overlays the signal from two input matrices
#Primary use is to overlay SpLiT-ChEC and MNase-seq signal for NFR analysis

inmat <- in_mat
innucs <- in_nucs

m <- na.omit(read.delim(file = inmat, sep = '\t', header = FALSE))
n <- na.omit(read.delim(file = innucs, sep = '\t', header = FALSE))

m_df <- data.frame(m)[-1, -(0:6)]
n_df <- data.frame(n)[-1, -(0:6)]

x <- c(-499:500)
m_v <- colMeans(m_df)
n_v <- colMeans(n_df)
pl_df <- (data.frame(x, m_v, n_v))[400:600,]

par(mar = c(5, 4, 4, 4) + 0.25)
plot(pl_df$x,pl_df$m_v,type="l",col="black", xlab = 'bp', ylab = 'SpLiT-ChEC signal', lwd = 2)
par(new=TRUE)
plot(pl_df$x,pl_df$n_v,type="l", lwd=2 , col="red", xlab = '', ylab = '', axes=FALSE, lty = "dotted")
axis(4)
mtext("MNase-seq signal", side = 4, line = 3, col = "red")

#ggplot(pl_df, aes(x, m_v, n_v))+
#	geom_line(aes(x, m_v))+
#	geom_line(aes(x, n_v))
