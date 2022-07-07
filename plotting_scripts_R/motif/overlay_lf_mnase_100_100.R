in_1 <- in_1
in_2 <- in_2
in_3 <- in_3
in_nucs <- in_nucs

t1 <- read.table(file = in_1, sep = '\t', header = FALSE)
t2 <- read.table(file = in_2, sep = '\t', header = FALSE)
t3 <- read.table(file = in_3, sep = '\t', header= FALSE)
nucs <- read.table(file = in_nucs, sep = '\t', header= FALSE)

t1_df <- data.frame(t(t1))[3:ncol(t1), 2:nrow(t1)]
t2_df <- data.frame(t(t2))[3:ncol(t2), 2:nrow(t2)]
t3_df <- data.frame(t(t3))[3:ncol(t3), 2:nrow(t3)]
nucs_df <- data.frame(t(nucs))[3:ncol(nucs), 2:nrow(nucs)]

t1_val <- t1_df[900:1100, 2]
t2_val <- t2_df[900:1100, 2]
t3_val <- t3_df[900:1100, 2]
nucs_df <- nucs_df[900:1100, 2]
nucs_val <- as.numeric(nucs_df)
x <- seq(-100, 100, by=1)

par(mar = c(5, 4, 4, 4) + 0.25)
plot(x,t2_val,type="l",col="black", xlab = 'bp', ylab = 'Signal', lwd = 2)
abline(v=c(-75,-50,50,75), col="red", lty=2, lwd=3)
lines(x,t1_val,col="black")
lines(x,t3_val,col="black")
par(new=TRUE)
plot(x,nucs_val,type="l", lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Signal", side = 4, line = 3, col = 4)
#abline(v=c(50, -50), xpd=2, col="red", lty=2, lwd=2)
