### significance test
real<-read.table("merge_all.add.protein")
real <- real %>% replace(is.na(.), 0)
for (i in 2:length(real)){
pv<-NULL
for (j in 1:1000){
data<-read.table(paste("rand/rand_",j,".pexp",sep=""))
data <- data %>% replace(is.na(.), 0)
pv<-rbind(pv,t.test(na.omit(real[,i]),na.omit(data[,i]))$p.value)}
write.table(pv,file=paste("psnv_rand",i,".pexp.ttest",sep=""))}

real<-read.table("merge_all.add.exp")
real <- real %>% replace(is.na(.), 0)
for (i in 2:length(real)){
pv<-NULL
for (j in 1:1000){
data<-read.table(paste("rand/rand_",j,".exp",sep=""))
data <- data %>% replace(is.na(.), 0)
pv<-rbind(pv,t.test(na.omit(real[,i]),na.omit(data[,i]))$p.value)}
write.table(pv,file=paste("psnv_rand",i,".exp.ttest",sep=""))}