#avg_ff <- avg_ff
avg_sf <- avg_sf

#ff <- read.table(file = avg_ff, sep = '\t', header = FALSE)
sf <- read.table(file = avg_sf, sep = '\t', header = FALSE)

#ff_vals <- data.frame(ff)[4:21, 2]
sf_vals <- data.frame(sf)[1:18, 2]

x <- c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 30, 40, 50, 60, 70, 80, 90, 100)

par(new=TRUE)
plot(x,sf_vals, type = "l"  , lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Avg dyad per merge interval", side = 4, line = 3, col = 4)
