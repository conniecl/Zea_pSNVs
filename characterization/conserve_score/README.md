### significance test
```
gerp<-NULL
sift<-NULL
data<-read.table("merge_all.mutation.add.type",header=T)
real<-data[grep("fk",data$type),]
for (i in 1:1000)
{
	data<-read.table(paste("rand/rand_",i,".mutation.add.domain",sep=""),header=T)
	gerp<-rbind(gerp,t.test(na.omit(real$gerp),na.omit(data$gerp))$p.value)
	sift<-rbind(sift,t.test(na.omit(real$sift),na.omit(data$sift))$p.value)
}
write.table(gerp,file="psnv_rand.gerp.ttest")
write.table(sift,file="psnv_rand.sift.ttest")
```
