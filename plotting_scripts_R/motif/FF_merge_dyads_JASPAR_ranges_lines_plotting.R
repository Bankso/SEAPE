in_0 <- in_0_ff
in_20 <- in_20_ff
in_50 <- in_50_ff
in_100 <- in_100_ff
in_200 <- in_200_ff
in_500 <- in_500_ff
in_1000 <- in_1000_ff
in_totals <- in_totals_ff
in_c <- avg_ff

c_avg <- read.table(file = in_c, sep = '\t', header = FALSE)
x <- c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 30, 40, 50, 60, 70, 80, 90, 100, 120, 150, 200, 250, 300, 400, 500, 1000)
c_vals <- data.frame(merge_dis=x, count=c_avg[1:26, 2])


t1 <- read.table(file = in_0, sep = ' ', header = FALSE)
t2 <- read.table(file = in_20, sep = ' ', header = FALSE)
t3 <- read.table(file = in_50, sep = ' ', header= FALSE)
t4 <- read.table(file = in_100, sep = ' ', header = FALSE)
t5 <- read.table(file = in_200, sep = ' ', header = FALSE)
t6 <- read.table(file = in_500, sep = ' ', header= FALSE)
t7 <- read.table(file = in_1000, sep = ' ', header= FALSE)
tt <- read.table(file = in_totals, sep = ' ', header= FALSE)

t1_v <- t1[, 1]
t2_v <- t2[, 1]
t3_v <- t3[, 1]
t4_v <- t4[, 1]
t5_v <- t5[, 1]
t6_v <- t6[, 1]
t7_v <- t7[, 1]
in_order <- c(1000, 100, 10, 120, 12, 14, 150, 16, 18, 200, 20, 250, 2, 300, 30, 400, 40, 4, 500, 50, 60, 6, 70, 80, 8, 90)
tt_v <- tt[, 1]

all_df <- data.frame(x1=in_order, x2=t1_v, x3=t2_v, x4=t3_v, x5=t4_v, x6=t5_v, x7=t6_v, x8=t7_v, x9=tt_v)
in_order_sort <- sort(in_order)
names(all_df) <- c("merge_value", "JASPAR_0", "JASPAR_20", "JASPAR_50", "JASPAR_100", "JASPAR_200", "JASPAR_500", "JASPAR_1000", "total_dyads")
sorted_df <- all_df[order(all_df$merge_value), ]
sorted_df[-ncol(sorted_df)] <- sorted_df[-ncol(sorted_df)]/sorted_df$total_dyads
sorted_df$merge_value <- sorted_df$merge_value*sorted_df$total_dyads
#heatmap(as.matrix(sorted_df[, 2:8]), Rowv = NA, Colv = NA, keep.dendro = FALSE)
#heatmap.2(as.matrix(sorted_df[, 6]), trace = "n", Colv = NA, Rowv = NA, labCol = names(sorted_df[, 6]), labRow = in_order_sort, cexRow = 1)
#heatmap.2(cbind(sorted_df$JASPAR_50[1:23], sorted_df$JASPAR_50[1:23]), margins = c(4, 9), srtCol = 0, trace="n", Colv = NA, Rowv = NA, labCol = "JASPAR_50", labRow = in_order_sort, cexRow = 1, cexCol = 1, adjCol = c(-1.25,0.5), main = "Abf1 merged SF dyads near consensus sites", key = TRUE)
#heatmap(as.matrix(sorted_df[, 3:4]), Rowv = NA, Colv = NA, keep.dendro = FALSE)

p_r <- 1:24
par(mar = c(5, 5, 4, 4) + 0.25)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_0[p_r],type="l",col="red", xlab = 'Merge distance', ylab = 'Relative % of merged dyads within \n range of consensus sequence', lwd = 2, main = "Abf1 merged full fragment dyads", yaxt = "n")
legend("topright", legend = c("JASPAR 0", "JASPAR 20", "JASPAR 50", "JASPAR 100", "JASPAR 200", "JASPAR 500", "JASPAR 1000"), fill = c("red", "black", "blue", "green", "yellow", "purple", "orange"))
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_20[p_r],type="l",col="black", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_50[p_r],type="l",col="blue", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_100[p_r],type="l",col="green", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_200[p_r],type="l",col="yellow", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_500[p_r],type="l",col="purple", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new = TRUE)
plot(sorted_df$merge_value[p_r],sorted_df$JASPAR_1000[p_r],type="l",col="orange", xlab = '', ylab = '', axes=FALSE, lwd = 2)
par(new=TRUE)
plot(c_vals$merge_dis[p_r],c_vals$count[p_r], type = "l"  , lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
axis(4)
mtext("Avg dyads per merged site", side = 4, line = 3, col = 4)
#par(new=TRUE)
#plot(x,nucs_val,type="l", lwd=2 , col="dark blue", xlab = '', ylab = '', axes=FALSE)
#axis(4)
#abline(v=c(50, -50), xpd=2, col="red", lty=2, lwd=2)
