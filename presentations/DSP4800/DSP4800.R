library(ggplot2)
library(ggthemes)
library(reshape2)
library(lemon)

data <- read.csv("DSP4800.csv",header=T,sep=",",stringsAsFactors=F, check.names=FALSE)
data <- melt(data,id.vars=c("Benchmakrs"))

data
data$a <- factor(data$Benchmakrs, levels = c("CNN_0", "CNN_1", "CNN_2", "CNN_3", "CNN_4", "CNN_5", "CNN_6", "CNN_7", "CNN_8", "CNN_9", "CNN_10", "CNN_11", "GEMM_0", "GEMM_1", "GEMM_2", "GEMM_3", "GEMM_4", "GEMM_5", "GEMM_6", "GEMM_7", "GEMM_8", "GEMM_9", "GEMM_10", "GEMM_11", "GEMM_12", "GEMM_13", "GEMM_14", "GEMM_15", "GEMM_16", "GEMM_17", "GEMM_18", "RNN_0", "RNN_1", "RNN_2", "RNN_3", "RNN_4", "RNN_5", "RNN_6", "RNN_7"))
data
pdf("DSP4800.pdf",width=15,height=7)
#ggplot(data,aes(variable,value)) +
ggplot(data,aes(a,value)) +
    #geom_bar(aes(fill = a), position = "dodge", stat = "identity", width=0.7) +
    geom_bar(aes(fill=variable), position = "dodge", stat = "identity", width=0.6) +
    # coord_capped_cart(bottom='both', left='both') +
	xlab("Benchmarks") +
	ylab("Normalized Performance speedup") +
	theme(axis.title=element_text(),axis.title.y=theme_bw()$axis.title.y) +
	scale_fill_pander("") +
	theme_minimal() +
  	theme(
		legend.position="top",
		#legend.background = element_rect(fill="gray90"),
		legend.title=element_text(size=24,face="plain"),
		legend.key=element_blank(),
		legend.key.width=unit(0.8,"cm"),
		legend.key.height=unit(0.8,"cm"),
		axis.text.x=element_text(size=14,angle=90,hjust=0.5,vjust=0,face="bold"),
		axis.text.y=element_text(size=22,angle=0,hjust=1,face="bold"),
		axis.title.x = element_text(size=28,angle=0,hjust=.5,vjust=0,face="plain"),
        axis.title.y = element_text(size=28,hjust=.5,vjust=.5,face="plain"),
        #axis.line = element_line(colour = "black"),
        #panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.border=element_blank(),
        axis.line=element_line(),
        strip.text.x = element_text(size = 24,face="bold"),
		legend.text=element_text(size=24)) +
	guides(
		color=guide_legend(ncol=4,nrow=1)
	) +
	theme(axis.line = element_line(color = 'black'),
	panel.grid.major.y = element_line(colour = "black"),
	panel.grid.minor.y = element_line(colour = "black"))+
	#scale_fill_pander()
	#scale_fill_brewer(palette = "Spectral")
	scale_fill_brewer(palette = "Set1")

