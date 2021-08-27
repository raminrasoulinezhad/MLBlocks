library(ggplot2)
library(ggthemes)
library(reshape2)
library(lemon)

data <- read.csv("script_table_II.csv",header=T,sep=",",stringsAsFactors=F, check.names=FALSE)
data <- melt(data,id.vars=c("Benchmakrs"))


data
data$a <- factor(data$Benchmakrs, levels = c("GEMM","CNN","RNN","All"))
data
pdf("script_table_II.pdf",width=15,height=7)
#ggplot(data,aes(variable,value)) +
ggplot(data,aes(a,value)) +
    #geom_bar(aes(fill = a), position = "dodge", stat = "identity", width=0.7) +
    geom_bar(aes(fill=variable), position = "dodge", stat = "identity", width=0.6) +
    # coord_capped_cart(bottom='both', left='both') +
	xlab("Benchmarks") +
	ylab("(Utilization x MACs)/Area (normalized)") +
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
		axis.text.x=element_text(size=22,angle=0,hjust=0.5,vjust=0,face="bold"),
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

