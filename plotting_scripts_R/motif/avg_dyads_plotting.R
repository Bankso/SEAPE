#Plotting the average number of peak centers found in each site
#After a merge cycle. Used to locate optimal merge points in DIO calcs

avgcounts <- avg_dyad_counts

adc <- read.table(file = avgcounts, sep = '\t', header = FALSE)

adc_df <- data.frame(adc)[1:18, 2]

x <- c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 30, 40, 50, 60, 70, 80, 90, 100)

par(new=TRUE)
plot(x, adc_df, type = "l", lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Avg dyad per merge interval", side = 4, line = 3, col = 4)
