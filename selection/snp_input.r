args=commandArgs(T)
ogut<-read.table(paste(args[1],".genetic",sep=""),header=F,sep=" ")
colnames(ogut)=c("chr","pos","cm")
get_cM<-function(p)
{
    return(approx(ogut$pos,ogut$cm,p)$y)
}
startp=min(ogut$pos)
startg=min(ogut$cm)
endp=max(ogut$pos)
endg=max(ogut$cm)
y<-read.table(paste(args[1],".pos",sep=""),header=F)
#y<-as.matrix(y)
colnames(y)=c("chr","pos","ref","alt")
dataset=NULL
options(scipen = 200)
for (i in 1:nrow(y))
{
    if(y$pos[i]<=startp)
	{
		ge<-(y$pos[i]*startg/startp)/100
	}
	else if(y$pos[i]<=endp)
    {
        ge<-get_cM(y$pos[i])/100
    }
    else
    {
        ge<-(y$pos[i]*endg/endp)/100
    }
	cat(i,y$chr[i],ge,y$pos[i],y$ref[i],y$alt[i],"\n")
}
