in_sf <- sf_can_counts
in_ff <- ff_can_counts
can_total <- can_total

sf_val <- read.table(file = in_sf, sep = ' ', header = FALSE)
ff_val <- read.table(file = in_ff, sep = ' ', header = FALSE)

sf_trim <- as.numeric(sapply(str_split(sf_val$V1, "_"), "[[", 8))
ff_trim <- as.numeric(sapply(str_split(ff_val$V1, "_"), "[[", 9))

sf_df <- data.frame(merge_value=sf_trim, counts=sf_val$V3, avgs=sf_val$V5, can_percent=(sf_val$V3/can_total))
ff_df <- data.frame(merge_value=ff_trim, counts=ff_val$V3, avgs=ff_val$V5, can_percent=(ff_val$V3/can_total))
sf_df_sorted <- sf_df[order(sf_df$merge_value), ]
ff_df_sorted <- ff_df[order(ff_df$merge_value), ]

p_r <- 1:25
par(mar = c(5, 5, 4, 4) + 0.25)
plot(ff_df_sorted$merge_value[p_r],ff_df_sorted$can_percent[p_r],type="l",col="red", xlab = 'Merge distance', ylab = 'Percent of JASPAR dyads within \n merged regions', lwd = 2, main = "Reb1 JASPAR consensus dyads contained in merged footprints", yaxs = "r")
legend("bottomright", legend = c("FF percent captured", "FF can/dyad", "SF percent captured", "SF can/dyad"), fill = c("red", "black", "blue", "orange"))
par(new = TRUE)
plot(sf_df_sorted$merge_value[p_r],sf_df_sorted$can_percent[p_r],type="l",col="blue", xlab = '', ylab = '', axes=FALSE, lwd = 2)
abline(h=max(sf_df_sorted$can_percent[p_r]), col="blue", lty=2, lwd=2)
par(new = TRUE)
plot(ff_df_sorted$merge_value[p_r],ff_df_sorted$avgs[p_r],type="l",col="black", xlab = '', ylab = '', axes=FALSE, lwd = 2)
axis(4,  yaxs = "s")
mtext("Avg canonical dyads captured per merged site", side = 4, line = 3, col = 1)
abline(h=max(ff_df_sorted$avgs[p_r]), col="black", lty=2, lwd=2)
par(new = TRUE)
plot(sf_df_sorted$merge_value[p_r],sf_df_sorted$avgs[p_r],type="l",col="orange", xlab = '', ylab = '', axes=FALSE, lwd = 2)

