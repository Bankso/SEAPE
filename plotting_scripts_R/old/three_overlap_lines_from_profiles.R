in_1 <- in_1
in_2 <- in_2
in_3 <- in_3

t1 <- read.table(file = in_1, sep = '\t', header = FALSE)
t2 <- read.table(file = in_2, sep = '\t', header = FALSE)
t3 <- read.table(file = in_3, sep = '\t', header= FALSE)

t1_df <- data.frame(t(t1))[3:ncol(t1), 2:nrow(t1)]
t2_df <- data.frame(t(t2))[3:ncol(t2), 2:nrow(t2)]
t3_df <- data.frame(t(t3))[3:ncol(t3), 2:nrow(t3)]

t1_val <- t1_df[, 2]
t2_val <- t2_df[, 2]
t3_val <- t3_df[, 2]

x <- seq(-999, 1000, by=1)

plot(x,t1_val,type="l",col="black")
#lines(x,t1_val,col="blue")
#lines(x, t2_val,col="black")
