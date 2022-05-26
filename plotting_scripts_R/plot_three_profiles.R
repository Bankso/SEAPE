#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
in_1 <- args[1]
in_2 <- args[2]
in_3 <- args[3]

t1 <- read.table(file = in_1, sep = '\t', header = FALSE)
t2 <- read.table(file = in_2, sep = '\t', header = FALSE)
t3 <- read.table(file = in_3, sep = '\t', header= FALSE)

t1_df <- data.frame(t(t1))[3:ncol(t1), 2:nrow(t1)]
t2_df <- data.frame(t(t2))[3:ncol(t2), 2:nrow(t2)]
t3_df <- data.frame(t(t3))[3:ncol(t3), 2:nrow(t3)]

names(t1_df) <- c('position', 'signal')
names(t2_df) <- c('position', 'signal')
names(t3_df) <- c('position', 'signal')

ggplot(t1_df, aes(x=position, y=signal)) +geom_point() +geom_point(data=t2_df,colour='red') +geom_point(data=t3_df,colour='blue')
