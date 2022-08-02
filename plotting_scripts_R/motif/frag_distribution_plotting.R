library(ggplot2)

frags <- fdlist

fdflist <- lapply(frags, read.delim, sep = " ", header = FALSE)


plt <- ggplot(data.frame(fdflist[1]), aes(x = V2, y = V1))+
	geom_line(aes(), colour = "black")+
	geom_line(data = data.frame(fdflist[2]), mapping=aes(x = V2, y = V1), colour = "blue")+
	geom_line(data = data.frame(fdflist[3]), mapping=aes(x = V2, y = V1), colour = "red")+
	geom_line(data = data.frame(fdflist[4]), mapping=aes(x = V2, y = V1), colour = "black")+
	geom_line(data = data.frame(fdflist[5]), mapping=aes(x = V2, y = V1), colour = "blue")+
	geom_line(data = data.frame(fdflist[6]), mapping=aes(x = V2, y = V1), colour = "red")+
	theme_bw()+
	xlab("Sequencing insert size (bp)")+
	ylab("Fragments detected (counts)")

show(plt)

