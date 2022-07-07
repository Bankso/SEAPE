in_ff <- in_ff
in_sf <- in_sf


tf <- read.table(file = in_ff, sep = '\t', header = FALSE)
ts <- read.table(file = in_sf, sep = '\t', header = FALSE)


tf_df <- data.frame(t(tf))[ncol(tf), nrow(tf)]
ts_df <- data.frame(t(ts))[ncol(ts), nrow(ts)]


t1_val <- t1_df[, 1]
t2_val <- t2_df[, 2]
t3_val <- t3_df[, 3]
nucs_df <- nucs_df[, 2]
nucs_val <- as.numeric(nucs_df)
x <- seq(-999, 1000, by=1)

par(mar = c(5, 4, 4, 4) + 0.25)
plot(x,t2_val,type="l",col="black", xlab = 'bp', ylab = 'Signal', lwd = 2)
abline(v=c(50, -50), col="red", lty=2, lwd=3)
lines(x,t1_val,col="black")
lines(x,t3_val,col="black")
par(new=TRUE)
plot(x,nucs_val,type="l", lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Signal", side = 4, line = 3, col = 4)
#abline(v=c(50, -50), xpd=2, col="red", lty=2, lwd=2)
